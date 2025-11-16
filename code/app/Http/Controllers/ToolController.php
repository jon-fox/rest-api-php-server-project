<?php

namespace App\Http\Controllers;

use App\Models\Tool;
use Illuminate\Http\JsonResponse;

class ToolController extends Controller
{
    /**
     * Get all tools
     */
    public function index(): JsonResponse
    {
        $tools = Tool::orderBy('category')->orderBy('name')->get();
        return response()->json($tools->toArray());
    }
}
