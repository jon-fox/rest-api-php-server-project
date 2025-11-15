#!/bin/bash

cd "$(dirname "$0")"

read -p "Enter user email: " USER_EMAIL
read -p "Enter token name: " TOKEN_NAME

php -r "
require 'bootstrap.php';

use App\Models\User;

\$user = User::where('email', '$USER_EMAIL')->first();

if (!\$user) {
    echo \"User not found. Creating default user...\n\";
    \$user = User::create([
        'name' => 'Admin User',
        'email' => '$USER_EMAIL',
        'password' => bcrypt('password'),
    ]);
}

\$token = \$user->createToken('$TOKEN_NAME')->plainTextToken;

echo \"\n\";
echo \"Token created successfully!\n\";
echo \"================================\n\";
echo \"Token: \$token\n\";
echo \"================================\n\";
echo \"\n\";
echo \"Use in requests:\n\";
echo \"Authorization: Bearer \$token\n\";
"
