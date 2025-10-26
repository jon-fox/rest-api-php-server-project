<?php

require_once 'config.php';

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$method = $_SERVER['REQUEST_METHOD'];

if ($uri === '/docs' || $uri === '/') {
    header('Content-Type: text/html');
    readfile('docs.html');
    exit;
}

if ($uri === '/tests' || $uri === '/tests/test.html') {
    header('Content-Type: text/html');
    readfile('tests/test.html');
    exit;
}

$routes = [
    'GET' => [
        '/agents' => 'agents.php',
        '/agents/(\d+)' => 'agents.php',
        '/tasks' => 'tasks.php',
        '/tasks/(\d+)' => 'tasks.php',
        '/tasks/(\d+)/status' => 'tasks.php',
        '/tools' => 'tools.php',
        '/logs' => 'logs.php',
    ],
    'POST' => [
        '/agents' => 'agents.php',
        '/tasks' => 'tasks.php',
        '/agents/(\d+)/execute' => 'agents.php',
    ],
    'PUT' => [
        '/agents/(\d+)' => 'agents.php',
        '/tasks/(\d+)' => 'tasks.php',
    ],
    'DELETE' => [
        '/agents/(\d+)' => 'agents.php',
        '/tasks/(\d+)' => 'tasks.php',
    ],
];

if (!isset($routes[$method])) {
    sendJson(['error' => 'Method not allowed'], 405);
}

foreach ($routes[$method] as $pattern => $file) {
    if (preg_match('#^' . $pattern . '$#', $uri, $matches)) {
        array_shift($matches);
        $_GET['id'] = $matches[0] ?? null;
        $_GET['action'] = strpos($uri, '/execute') !== false ? 'execute' : 
                          (strpos($uri, '/status') !== false ? 'status' : null);
        require $file;
        exit;
    }
}

sendJson(['error' => 'Not found'], 404);
