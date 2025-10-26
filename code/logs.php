<?php

require_once 'config.php';

$pdo = getDbConnection();

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendJson(['error' => 'Method not allowed'], 405);
}

$limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 100;
$agentId = isset($_GET['agent_id']) ? (int)$_GET['agent_id'] : null;

if ($agentId) {
    $stmt = $pdo->prepare('SELECT * FROM logs WHERE agent_id = ? ORDER BY created_at DESC LIMIT ?');
    $stmt->bindValue(1, $agentId, PDO::PARAM_INT);
    $stmt->bindValue(2, $limit, PDO::PARAM_INT);
    $stmt->execute();
} else {
    $stmt = $pdo->prepare('SELECT * FROM logs ORDER BY created_at DESC LIMIT ?');
    $stmt->bindValue(1, $limit, PDO::PARAM_INT);
    $stmt->execute();
}

sendJson($stmt->fetchAll());
