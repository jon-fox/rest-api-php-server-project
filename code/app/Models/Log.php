<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Log extends Model
{
    protected $table = 'logs';
    
    protected $fillable = [
        'agent_id',
        'task_id',
        'level',
        'message'
    ];
    
    protected $casts = [
        'agent_id' => 'integer',
        'task_id' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
    
    public function agent()
    {
        return $this->belongsTo(Agent::class);
    }
    
    public function task()
    {
        return $this->belongsTo(Task::class);
    }
}
