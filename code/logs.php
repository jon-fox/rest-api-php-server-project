<?php

require_once 'bootstrap.php';
require_once 'config.php';

use App\Models\Log;

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendJson(['error' => 'Method not allowed'], 405);
}

$limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 100;
$agentId = isset($_GET['agent_id']) ? (int)$_GET['agent_id'] : null;

$query = Log::orderByDesc('created_at')->limit($limit);

if ($agentId) {
    $query->where('agent_id', $agentId);
}

$logs = $query->get();
sendJson($logs->toArray());
