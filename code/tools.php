<?php

require_once 'bootstrap.php';
require_once 'config.php';

use App\Models\Tool;

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendJson(['error' => 'Method not allowed'], 405);
}

$tools = Tool::orderBy('category')->orderBy('name')->get();
sendJson($tools->toArray());
