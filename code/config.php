<?php

error_reporting(E_ALL);
ini_set('display_errors', '0');
ini_set('log_errors', '1');

define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
define('DB_NAME', 'agent_management');
define('DB_USER', getenv('DB_USER') ?: 'root');
define('DB_PASS', getenv('MYSQL_PWD') ?: '');

function getDbConnection() {
    try {
        $pdo = new PDO(
            "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4",
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
    
    $pdo = getDbConnection();
    $stmt = $pdo->prepare('SELECT id FROM api_tokens WHERE token = ? AND (expires_at IS NULL OR expires_at > NOW())');
    $stmt->execute([$token]);
    
    if (!$stmt->fetch()) {
        http_response_code(401);
        echo json_encode(['error' => 'Invalid or expired token']);
        exit;
    }
}

function sendJson($data, $statusCode = 200) {
    http_response_code($statusCode);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}
