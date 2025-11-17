#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Creating .env file for Docker..."
cat > code/.env << 'EOF'
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=agent_management
DB_USERNAME=root
DB_PASSWORD=secret
EOF

echo "Building and starting containers..."
docker compose down -v
docker compose up -d --build

echo "Waiting for MySQL to be ready..."
sleep 10

echo "Installing dependencies..."
docker compose exec app composer install --no-interaction --optimize-autoloader

echo "Generating Laravel application key..."
docker compose exec app php artisan key:generate --force

echo "Running database migrations..."
docker compose exec app php artisan migrate:fresh --force

echo "Seeding database with sample data..."
docker compose exec app php artisan db:seed --force

echo "Generating API token for tests..."
API_TOKEN=$(docker compose exec app php artisan tinker --execute="
\$user = \App\Models\User::first();
if (!\$user) {
    \$user = \App\Models\User::factory()->create(['name' => 'Test User', 'email' => 'test@example.com']);
}
\$user->tokens()->delete();
echo \$user->createToken('test-token')->plainTextToken;
" | tr -d '\r')

echo ""
echo "Setup completed successfully!"
echo "API running at http://localhost:8000"
echo "  Docs: http://localhost:8000/docs"
echo "  API base: http://localhost:8000/api"
echo ""
echo "API Token: $API_TOKEN"
echo ""
echo "To stop: docker compose down"
echo ""
