<?php

namespace App\Http\Controllers;

use App\Models\Agent;
use App\Models\Log;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class AgentController extends Controller
{
    /**
     * Get all agents
     */
    public function index(): JsonResponse
    {
        $agents = Agent::orderBy('id')->get();
        return response()->json($agents->toArray());
    }

    /**
     * Get a single agent
     */
    public function show($id): JsonResponse
    {
        $agent = Agent::find($id);
        
        if (!$agent) {
            return response()->json(['error' => 'Agent not found'], 404);
        }
        
        return response()->json($agent->toArray());
    }

    /**
     * Create a new agent
     */
    public function store(Request $request): JsonResponse
    {
        if (!$request->has('name')) {
            return response()->json(['error' => 'Name is required'], 400);
        }
        
        $agent = Agent::create([
            'name' => $request->input('name'),
            'description' => $request->input('description'),
            'status' => $request->input('status', 'idle')
        ]);
        
        return response()->json(['id' => $agent->id, 'message' => 'Agent created'], 201);
    }

    /**
     * Update an existing agent
     */
    public function update(Request $request, $id): JsonResponse
    {
        $agent = Agent::find($id);
        
        if (!$agent) {
            return response()->json(['error' => 'Agent not found'], 404);
        }
        
        if ($request->has('name')) $agent->name = $request->input('name');
        if ($request->has('description')) $agent->description = $request->input('description');
        if ($request->has('status')) $agent->status = $request->input('status');
        
        if (!$agent->isDirty()) {
            return response()->json(['error' => 'No fields to update'], 400);
        }
        
        $agent->save();
        
        return response()->json(['message' => 'Agent updated']);
    }

    /**
     * Delete an agent
     */
    public function destroy($id): JsonResponse
    {
        $agent = Agent::find($id);
        
        if (!$agent) {
            return response()->json(['error' => 'Agent not found'], 404);
        }
        
        $agent->delete();
        
        return response()->json(['message' => 'Agent deleted']);
    }

    /**
     * Execute an agent
     */
    public function execute($id): JsonResponse
    {
        $agent = Agent::find($id);
        
        if (!$agent) {
            return response()->json(['error' => 'Agent not found'], 404);
        }
        
        $agent->status = 'running';
        $agent->save();
        
        Log::create([
            'agent_id' => $id,
            'level' => 'info',
            'message' => "Agent {$agent->name} execution started"
        ]);
        
        return response()->json(['message' => 'Agent execution started', 'agent_id' => $id]);
    }
}
