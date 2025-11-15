<?php

use Illuminate\Database\Capsule\Manager as Capsule;

Capsule::schema()->create('personal_access_tokens', function ($table) {
    $table->id();
    $table->morphs('tokenable');
    $table->string('name');
    $table->string('token', 64)->unique();
    $table->text('abilities')->nullable();
    $table->timestamp('last_used_at')->nullable();
    $table->timestamp('expires_at')->nullable();
    $table->timestamps();
});

echo "Created personal_access_tokens table\n";
