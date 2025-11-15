<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Hash;

class ApiToken extends Model
{
    protected $table = 'api_tokens';
    
    protected $fillable = [
        'token',
        'description',
        'expires_at'
    ];
    
    protected $casts = [
        'expires_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
    
    public function isValid()
    {
        return $this->expires_at === null || $this->expires_at->isFuture();
    }
    
    public static function validateToken($token)
    {
        $apiToken = self::where('token', $token)->first();
        
        if (!$apiToken) {
            return false;
        }
        
        return $apiToken->isValid();
    }
}
