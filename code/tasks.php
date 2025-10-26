<?php

require_once 'config.php';

$pdo = getDbConnection();
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    if (isset($_GET['action']) && $_GET['action'] === 'status') {
        $taskId = $_GET['id'];
        $stmt = $pdo->prepare('SELECT id, status FROM tasks WHERE id = ?');
        $stmt->execute([$taskId]);
        $task = $stmt->fetch();
        
        if (!$task) {
            sendJson(['error' => 'Task not found'], 404);
        }
        
        sendJson(['task_id' => $task['id'], 'status' => $task['status']]);
    } elseif (isset($_GET['id'])) {
        $stmt = $pdo->prepare('SELECT * FROM tasks WHERE id = ?');
        $stmt->execute([$_GET['id']]);
        $task = $stmt->fetch();
        
        if (!$task) {
            sendJson(['error' => 'Task not found'], 404);
        }
        
        sendJson($task);
    } else {
        $stmt = $pdo->query('SELECT * FROM tasks ORDER BY priority DESC, id');
        sendJson($stmt->fetchAll());
    }
}

if (in_array($method, ['POST', 'PUT', 'DELETE'])) {
    validateBearerToken();
}

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($data['title'])) {
        sendJson(['error' => 'Title is required'], 400);
    }
    
    try {
        $stmt = $pdo->prepare('INSERT INTO tasks (agent_id, title, description, status, priority) VALUES (?, ?, ?, ?, ?)');
        $stmt->execute([
            $data['agent_id'] ?? null,
            $data['title'],
            $data['description'] ?? null,
            $data['status'] ?? 'pending',
            $data['priority'] ?? 0
        ]);
        
        sendJson(['id' => $pdo->lastInsertId(), 'message' => 'Task created'], 201);
    } catch (PDOException $e) {
        if ($e->getCode() == 23000) {
            sendJson(['error' => 'Invalid agent_id: Agent does not exist'], 400);
        }
        sendJson(['error' => 'Failed to create task'], 500);
    }
}

if ($method === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    $taskId = $_GET['id'];
    
    $stmt = $pdo->prepare('SELECT id FROM tasks WHERE id = ?');
    $stmt->execute([$taskId]);
    
    if (!$stmt->fetch()) {
        sendJson(['error' => 'Task not found'], 404);
    }
    
    $fields = [];
    $values = [];
    
    foreach (['agent_id', 'title', 'description', 'status', 'priority'] as $field) {
        if (isset($data[$field])) {
            $fields[] = "$field = ?";
            $values[] = $data[$field];
        }
    }
    
    if (empty($fields)) {
        sendJson(['error' => 'No fields to update'], 400);
    }
    
    $values[] = $taskId;
    $stmt = $pdo->prepare('UPDATE tasks SET ' . implode(', ', $fields) . ' WHERE id = ?');
    $stmt->execute($values);
    
    sendJson(['message' => 'Task updated']);
}

if ($method === 'DELETE') {
    $taskId = $_GET['id'];
    
    $stmt = $pdo->prepare('SELECT id FROM tasks WHERE id = ?');
    $stmt->execute([$taskId]);
    
    if (!$stmt->fetch()) {
        sendJson(['error' => 'Task not found'], 404);
    }
    
    $stmt = $pdo->prepare('DELETE FROM tasks WHERE id = ?');
    $stmt->execute([$taskId]);
    
    sendJson(['message' => 'Task deleted']);
}
