#!/bin/bash#!/bin/bash



cd "$(dirname "$0")"cd "$(dirname "$0")"



read -p "Enter user email (default: admin@example.com): " USER_EMAILread -p "Enter user email: " USER_EMAIL

USER_EMAIL=${USER_EMAIL:-admin@example.com}read -p "Enter token name: " TOKEN_NAME



read -p "Enter token name (default: api-token): " TOKEN_NAMEphp -r "

TOKEN_NAME=${TOKEN_NAME:-api-token}require 'bootstrap.php';



TOKEN=$(php artisan tinker --execute="use App\Models\User;

\$user = App\Models\User::where('email', '$USER_EMAIL')->first();

if (!\$user) {\$user = User::where('email', '$USER_EMAIL')->first();

    \$user = App\Models\User::create([

        'name' => 'Admin User',if (!\$user) {

        'email' => '$USER_EMAIL',    echo \"User not found. Creating default user...\n\";

        'password' => bcrypt('password'),    \$user = User::create([

    ]);        'name' => 'Admin User',

    echo 'User created. ';        'email' => '$USER_EMAIL',

}        'password' => bcrypt('password'),

\$token = \$user->createToken('$TOKEN_NAME')->plainTextToken;    ]);

echo \$token;}

")

\$token = \$user->createToken('$TOKEN_NAME')->plainTextToken;

echo ""

echo "Token created successfully!"echo \"\n\";

echo "================================"echo \"Token created successfully!\n\";

echo "$TOKEN"echo \"================================\n\";

echo "================================"echo \"Token: \$token\n\";

echo ""echo \"================================\n\";

echo "Use in requests:"echo \"\n\";

echo "Authorization: Bearer $TOKEN"echo \"Use in requests:\n\";

echo ""echo \"Authorization: Bearer \$token\n\";

"
