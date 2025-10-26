<?php

require_once 'config.php';

$pdo = getDbConnection();
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    if (isset($_GET['id'])) {
        $stmt = $pdo->prepare('SELECT * FROM agents WHERE id = ?');
        $stmt->execute([$_GET['id']]);
        $agent = $stmt->fetch();
        
        if (!$agent) {
            sendJson(['error' => 'Agent not found'], 404);
        }
        
        sendJson($agent);
    } else {
        $stmt = $pdo->query('SELECT * FROM agents ORDER BY id');
        sendJson($stmt->fetchAll());
    }
}

if (in_array($method, ['POST', 'PUT', 'DELETE']) || isset($_GET['action'])) {
    validateBearerToken();
}

if ($method === 'POST') {
    if (isset($_GET['action']) && $_GET['action'] === 'execute') {
        $agentId = $_GET['id'];
        $stmt = $pdo->prepare('SELECT * FROM agents WHERE id = ?');
        $stmt->execute([$agentId]);
        $agent = $stmt->fetch();
        
        if (!$agent) {
            sendJson(['error' => 'Agent not found'], 404);
        }
        
        $stmt = $pdo->prepare('UPDATE agents SET status = "running" WHERE id = ?');
        $stmt->execute([$agentId]);
        
        $stmt = $pdo->prepare('INSERT INTO logs (agent_id, level, message) VALUES (?, "info", ?)');
        $stmt->execute([$agentId, "Agent {$agent['name']} execution started"]);
        
        sendJson(['message' => 'Agent execution started', 'agent_id' => $agentId]);
    } else {
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!isset($data['name'])) {
            sendJson(['error' => 'Name is required'], 400);
        }
        
        $stmt = $pdo->prepare('INSERT INTO agents (name, description, status) VALUES (?, ?, ?)');
        $stmt->execute([
            $data['name'],
            $data['description'] ?? null,
            $data['status'] ?? 'idle'
        ]);
        
        sendJson(['id' => $pdo->lastInsertId(), 'message' => 'Agent created'], 201);
    }
}

if ($method === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    $agentId = $_GET['id'];
    
    $stmt = $pdo->prepare('SELECT id FROM agents WHERE id = ?');
    $stmt->execute([$agentId]);
    
    if (!$stmt->fetch()) {
        sendJson(['error' => 'Agent not found'], 404);
    }
    
    $fields = [];
    $values = [];
    
    if (isset($data['name'])) {
        $fields[] = 'name = ?';
        $values[] = $data['name'];
    }
    if (isset($data['description'])) {
        $fields[] = 'description = ?';
        $values[] = $data['description'];
    }
    if (isset($data['status'])) {
        $fields[] = 'status = ?';
        $values[] = $data['status'];
    }
    
    if (empty($fields)) {
        sendJson(['error' => 'No fields to update'], 400);
    }
    
    $values[] = $agentId;
    $stmt = $pdo->prepare('UPDATE agents SET ' . implode(', ', $fields) . ' WHERE id = ?');
    $stmt->execute($values);
    
    sendJson(['message' => 'Agent updated']);
}

if ($method === 'DELETE') {
    $agentId = $_GET['id'];
    
    $stmt = $pdo->prepare('SELECT id FROM agents WHERE id = ?');
    $stmt->execute([$agentId]);
    
    if (!$stmt->fetch()) {
        sendJson(['error' => 'Agent not found'], 404);
    }
    
    $stmt = $pdo->prepare('DELETE FROM agents WHERE id = ?');
    $stmt->execute([$agentId]);
    
    sendJson(['message' => 'Agent deleted']);
}
