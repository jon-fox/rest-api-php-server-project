<?php

require_once 'bootstrap.php';
require_once 'config.php';

use App\Models\Agent;
use App\Models\Log;

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    if (isset($_GET['id'])) {
        $agent = Agent::find($_GET['id']);
        
        if (!$agent) {
            sendJson(['error' => 'Agent not found'], 404);
        }
        
        sendJson($agent->toArray());
    } else {
        $agents = Agent::orderBy('id')->get();
        sendJson($agents->toArray());
    }
}

if (in_array($method, ['POST', 'PUT', 'DELETE']) || isset($_GET['action'])) {
    validateBearerToken();
}

if ($method === 'POST') {
    if (isset($_GET['action']) && $_GET['action'] === 'execute') {
        $agentId = $_GET['id'];
        $agent = Agent::find($agentId);
        
        if (!$agent) {
            sendJson(['error' => 'Agent not found'], 404);
        }
        
        $agent->status = 'running';
        $agent->save();
        
        Log::create([
            'agent_id' => $agentId,
            'level' => 'info',
            'message' => "Agent {$agent->name} execution started"
        ]);
        
        sendJson(['message' => 'Agent execution started', 'agent_id' => $agentId]);
    } else {
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!isset($data['name'])) {
            sendJson(['error' => 'Name is required'], 400);
        }
        
        $agent = Agent::create([
            'name' => $data['name'],
            'description' => $data['description'] ?? null,
            'status' => $data['status'] ?? 'idle'
        ]);
        
        sendJson(['id' => $agent->id, 'message' => 'Agent created'], 201);
    }
}

if ($method === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    $agentId = $_GET['id'];
    
    $agent = Agent::find($agentId);
    
    if (!$agent) {
        sendJson(['error' => 'Agent not found'], 404);
    }
    
    if (isset($data['name'])) $agent->name = $data['name'];
    if (isset($data['description'])) $agent->description = $data['description'];
    if (isset($data['status'])) $agent->status = $data['status'];
    
    if (!$agent->isDirty()) {
        sendJson(['error' => 'No fields to update'], 400);
    }
    
    $agent->save();
    
    sendJson(['message' => 'Agent updated']);
}

if ($method === 'DELETE') {
    $agentId = $_GET['id'];
    
    $agent = Agent::find($agentId);
    
    if (!$agent) {
        sendJson(['error' => 'Agent not found'], 404);
    }
    
    $agent->delete();
    
    sendJson(['message' => 'Agent deleted']);
}
