<?php

require_once 'bootstrap.php';
require_once 'config.php';

use App\Models\Task;

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    if (isset($_GET['action']) && $_GET['action'] === 'status') {
        $task = Task::find($_GET['id']);
        
        if (!$task) {
            sendJson(['error' => 'Task not found'], 404);
        }
        
        sendJson(['task_id' => $task->id, 'status' => $task->status]);
    } elseif (isset($_GET['id'])) {
        $task = Task::find($_GET['id']);
        
        if (!$task) {
            sendJson(['error' => 'Task not found'], 404);
        }
        
        sendJson($task->toArray());
    } else {
        $tasks = Task::orderByDesc('priority')->orderBy('id')->get();
        sendJson($tasks->toArray());
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
        $task = Task::create([
            'agent_id' => $data['agent_id'] ?? null,
            'title' => $data['title'],
            'description' => $data['description'] ?? null,
            'status' => $data['status'] ?? 'pending',
            'priority' => $data['priority'] ?? 0
        ]);
        
        sendJson(['id' => $task->id, 'message' => 'Task created'], 201);
    } catch (\Exception $e) {
        if (strpos($e->getMessage(), 'foreign key') !== false) {
            sendJson(['error' => 'Invalid agent_id: Agent does not exist'], 400);
        }
        sendJson(['error' => 'Failed to create task'], 500);
    }
}

if ($method === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    $task = Task::find($_GET['id']);
    
    if (!$task) {
        sendJson(['error' => 'Task not found'], 404);
    }
    
    foreach (['agent_id', 'title', 'description', 'status', 'priority'] as $field) {
        if (isset($data[$field])) {
            $task->$field = $data[$field];
        }
    }
    
    if (!$task->isDirty()) {
        sendJson(['error' => 'No fields to update'], 400);
    }
    
    $task->save();
    sendJson(['message' => 'Task updated']);
}

if ($method === 'DELETE') {
    $task = Task::find($_GET['id']);
    
    if (!$task) {
        sendJson(['error' => 'Task not found'], 404);
    }
    
    $task->delete();
    sendJson(['message' => 'Task deleted']);
}
