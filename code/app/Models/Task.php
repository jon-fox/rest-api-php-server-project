<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    protected $table = 'tasks';
    
    protected $fillable = [
        'agent_id',
        'title',
        'description',
        'status',
        'priority'
    ];
    
    protected $casts = [
        'agent_id' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
    
    public function agent()
    {
        return $this->belongsTo(Agent::class);
    }
}
