<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Agent extends Model
{
    protected $table = 'agents';
    
    protected $fillable = [
        'name',
        'description',
        'status'
    ];
    
    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
    
    public function tasks()
    {
        return $this->hasMany(Task::class);
    }
    
    public function logs()
    {
        return $this->hasMany(Log::class);
    }
}
