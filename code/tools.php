<?php

require_once 'config.php';

$pdo = getDbConnection();

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendJson(['error' => 'Method not allowed'], 405);
}

$stmt = $pdo->query('SELECT * FROM tools ORDER BY category, name');
sendJson($stmt->fetchAll());
