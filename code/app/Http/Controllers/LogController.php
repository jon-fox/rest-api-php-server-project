<?php

namespace App\Http\Controllers;

use App\Models\Log;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class LogController extends Controller
{
    /**
     * Get logs with optional filtering
     */
    public function index(Request $request): JsonResponse
    {
        $limit = $request->input('limit', 100);
        $agentId = $request->input('agent_id');

        $query = Log::orderByDesc('created_at')->limit($limit);

        if ($agentId) {
            $query->where('agent_id', $agentId);
        }

        $logs = $query->get();
        return response()->json($logs->toArray());
    }
}
