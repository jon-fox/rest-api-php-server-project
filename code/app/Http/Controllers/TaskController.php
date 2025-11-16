<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class TaskController extends Controller
{
    /**
     * Get all tasks
     */
    public function index(): JsonResponse
    {
        $tasks = Task::orderByDesc('priority')->orderBy('id')->get();
        return response()->json($tasks->toArray());
    }

    /**
     * Get a single task
     */
    public function show($id): JsonResponse
    {
        $task = Task::find($id);
        
        if (!$task) {
            return response()->json(['error' => 'Task not found'], 404);
        }
        
        return response()->json($task->toArray());
    }

    /**
     * Get task status
     */
    public function status($id): JsonResponse
    {
        $task = Task::find($id);
        
        if (!$task) {
            return response()->json(['error' => 'Task not found'], 404);
        }
        
        return response()->json(['task_id' => $task->id, 'status' => $task->status]);
    }

    /**
     * Create a new task
     */
    public function store(Request $request): JsonResponse
    {
        if (!$request->has('title')) {
            return response()->json(['error' => 'Title is required'], 400);
        }
        
        try {
            $task = Task::create([
                'agent_id' => $request->input('agent_id'),
                'title' => $request->input('title'),
                'description' => $request->input('description'),
                'status' => $request->input('status', 'pending'),
                'priority' => $request->input('priority', 0)
            ]);
            
            return response()->json(['id' => $task->id, 'message' => 'Task created'], 201);
        } catch (\Exception $e) {
            if (strpos($e->getMessage(), 'foreign key') !== false) {
                return response()->json(['error' => 'Invalid agent_id: Agent does not exist'], 400);
            }
            return response()->json(['error' => 'Failed to create task'], 500);
        }
    }

    /**
     * Update an existing task
     */
    public function update(Request $request, $id): JsonResponse
    {
        $task = Task::find($id);
        
        if (!$task) {
            return response()->json(['error' => 'Task not found'], 404);
        }
        
        foreach (['agent_id', 'title', 'description', 'status', 'priority'] as $field) {
            if ($request->has($field)) {
                $task->$field = $request->input($field);
            }
        }
        
        if (!$task->isDirty()) {
            return response()->json(['error' => 'No fields to update'], 400);
        }
        
        $task->save();
        return response()->json(['message' => 'Task updated']);
    }

    /**
     * Delete a task
     */
    public function destroy($id): JsonResponse
    {
        $task = Task::find($id);
        
        if (!$task) {
            return response()->json(['error' => 'Task not found'], 404);
        }
        
        $task->delete();
        return response()->json(['message' => 'Task deleted']);
    }
}
