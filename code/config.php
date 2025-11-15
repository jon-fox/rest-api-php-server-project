<?php

error_reporting(E_ALL);
ini_set('display_errors', '0');
ini_set('log_errors', '1');

// Lightweight .env loader (no external deps). Reads key=value lines.
function loadEnv($path) {
    if (!is_readable($path)) return;
    $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        $line = trim($line);
        if ($line === '' || $line[0] === '#') continue;
        $pos = strpos($line, '=');
        if ($pos === false) continue;
        $key = trim(substr($line, 0, $pos));
        $val = trim(substr($line, $pos + 1));
        // strip simple quotes
        if ((str_starts_with($val, '"') && str_ends_with($val, '"')) || (str_starts_with($val, "'") && str_ends_with($val, "'"))) {
            $val = substr($val, 1, -1);
        }
        putenv($key . '=' . $val);
    }
}

// Load .env from project code directory if present
loadEnv(__DIR__ . '/.env');

// Force TCP by default to avoid Unix socket mismatches under PHP-FPM
define('DB_HOST', getenv('DB_HOST') ?: '127.0.0.1');
define('DB_PORT', getenv('DB_PORT') ?: '3306');
define('DB_NAME', getenv('DB_NAME') ?: 'agent_management');
define('DB_USER', getenv('DB_USER') ?: 'root');
// Prefer DB_PASS, fallback to MYSQL_PWD, then empty
$__db_pass = getenv('DB_PASS');
if ($__db_pass === false || $__db_pass === null || $__db_pass === '') {
    $__db_pass = getenv('MYSQL_PWD');
}
define('DB_PASS', $__db_pass ?: '');

function getDbConnection() {
    try {
        $pdo = new PDO(
            "mysql:host=" . DB_HOST . ";port=" . DB_PORT . ";dbname=" . DB_NAME . ";charset=utf8mb4",
            DB_USER,
            DB_PASS,
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
            ]
        );
        return $pdo;
    } catch (PDOException $e) {
        http_response_code(500);
        // Log detailed reason to error log for debugging, but keep API response generic
        error_log('DB connection failed: ' . $e->getMessage() . ' (host=' . DB_HOST . ', user=' . DB_USER . ', db=' . DB_NAME . ')');
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Database connection failed']);
        exit;
    }
}

function validateBearerToken() {
    $headers = getallheaders();
    $token = null;
    
    if (isset($headers['Authorization'])) {
        $matches = [];
        if (preg_match('/Bearer\s+(.*)$/i', $headers['Authorization'], $matches)) {
            $token = $matches[1];
        }
    }
    
    if (!$token) {
        http_response_code(401);
        echo json_encode(['error' => 'Authentication required']);
        exit;
    }
    
    if (class_exists('App\Models\ApiToken')) {
        if (!App\Models\ApiToken::validateToken($token)) {
            http_response_code(401);
            echo json_encode(['error' => 'Invalid or expired token']);
            exit;
        }
    } else {
        $pdo = getDbConnection();
        $stmt = $pdo->prepare('SELECT id FROM api_tokens WHERE token = ? AND (expires_at IS NULL OR expires_at > NOW())');
        $stmt->execute([$token]);
        
        if (!$stmt->fetch()) {
            http_response_code(401);
            echo json_encode(['error' => 'Invalid or expired token']);
            exit;
        }
    }
}

function sendJson($data, $statusCode = 200) {
    http_response_code($statusCode);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}
