<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tasks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('agent_id')->nullable()->constrained('agents')->onDelete('cascade');
            $table->string('title');
            $table->text('description')->nullable();
            $table->enum('status', ['pending', 'running', 'completed', 'failed'])->default('pending');
            $table->integer('priority')->default(0);
            $table->timestamps();
            
            $table->index('status', 'idx_task_status');
            $table->index('agent_id', 'idx_task_agent');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tasks');
    }
};
