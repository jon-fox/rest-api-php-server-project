<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('agent_id')->nullable()->constrained('agents')->onDelete('cascade');
            $table->foreignId('task_id')->nullable()->constrained('tasks')->onDelete('cascade');
            $table->enum('level', ['info', 'warning', 'error', 'debug'])->default('info');
            $table->text('message');
            $table->timestamps();
            
            $table->index('agent_id', 'idx_logs_agent');
            $table->index('task_id', 'idx_logs_task');
            $table->index('created_at', 'idx_logs_created');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('logs');
    }
};
