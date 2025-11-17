#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODE_DIR="$PROJECT_ROOT/code"

echo "=== Laravel REST API - One-Command Deployment ==="
echo ""

if grep -q "DB_HOST=mysql" "$CODE_DIR/.env" 2>/dev/null || [ ! -f "$CODE_DIR/.env" ]; then
    echo "Docker configuration detected..."
    
    if ! docker compose ps | grep -q "mysql.*running"; then
        echo "Docker containers not running. Starting setup..."
        bash "$PROJECT_ROOT/setup.sh"
        exit 0
    fi
    
    AGENT_COUNT=$(docker compose exec -T app php artisan tinker --execute="echo \App\Models\Agent::count();" 2>/dev/null | tail -1 | tr -d '\r\n')
    
    if [ "$AGENT_COUNT" = "0" ] || [ -z "$AGENT_COUNT" ]; then
        echo "Database is empty. Seeding data..."
        docker compose exec app php artisan db:seed --force
        echo "Database seeded successfully"
        echo ""
    fi

    echo "Generating API token for testing..."
    API_TOKEN=$(docker compose exec -T app php artisan tinker --execute="
\$user = \App\Models\User::first();
if (!\$user) {
    \$user = \App\Models\User::factory()->create(['name' => 'Test User', 'email' => 'test@example.com']);
}
\$user->tokens()->delete();
echo \$user->createToken('test-token')->plainTextToken;
" 2>/dev/null | grep -o '[0-9]*|[A-Za-z0-9]*' | head -1)

    echo ""
    echo "=========================================="
    echo "API is running at http://localhost:8000"
    echo "  Docs: http://localhost:8000/docs"
    echo "  Tests: http://localhost:8000/tests"
    echo "  API base: http://localhost:8000/api"
    echo ""
    if [ -n "$API_TOKEN" ]; then
        echo "API Token (copy and paste):"
        echo ""
        echo "  $API_TOKEN"
        echo ""
    else
        echo "Warning: Failed to generate API token"
        echo "Run: docker compose exec app php artisan tinker"
        echo "Then: User::first()->createToken('test-token')->plainTextToken"
    fi
    echo "To stop: docker compose down"
    echo "To rebuild: docker compose down && bash run.sh"
    echo "=========================================="
    exit 0
fi

cd "$CODE_DIR"

if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "Created .env from .env.example"
        echo "  Edit code/.env to set your database credentials"
    else
        echo "Error: .env.example not found"
        exit 1
    fi
fi

if [ ! -d "vendor" ]; then
    echo "Installing Composer dependencies..."
    if ! command -v composer &> /dev/null; then
        echo "Error: Composer not found. Install from https://getcomposer.org/"
        exit 1
    fi
    composer install --no-interaction --prefer-dist --optimize-autoloader
    echo "Dependencies installed"
fi

echo "Generating application key..."
if grep -q "APP_KEY=$" .env || ! grep -q "APP_KEY=" .env; then
    php artisan key:generate --ansi
    echo "Application key generated"
else
    echo "Application key already set"
fi

echo "Checking database connection..."
DB_PASSWORD=$(grep "^DB_PASSWORD=" .env | cut -d'=' -f2)
if [ -z "$DB_PASSWORD" ]; then
    read -sp "Enter MySQL root password: " DB_PASSWORD
    echo ""
    if grep -q "^DB_PASSWORD=" .env; then
        sed -i '' "s/^DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" .env
    else
        echo "DB_PASSWORD=$DB_PASSWORD" >> .env
    fi
fi

echo "Running database migrations..."
php artisan migrate:fresh --force
echo "Database migrations completed"

echo "Seeding database with sample data..."
php artisan db:seed --force
echo "Database seeded successfully"

if [ -f "$PROJECT_ROOT/code/database/seed.sql" ]; then
    echo "Loading additional seed data from seed.sql..."
    mysql -u root -h 127.0.0.1 agent_management < "$PROJECT_ROOT/code/database/seed.sql" 2>/dev/null && echo "Additional seed data loaded" || echo "Note: Additional seeding failed"
fi

echo "Generating API token for testing..."
API_TOKEN=$(php artisan tinker --execute="
\$user = \App\Models\User::first();
if (!\$user) {
    \$user = \App\Models\User::factory()->create(['name' => 'Test User', 'email' => 'test@example.com']);
}
\$user->tokens()->delete();
echo \$user->createToken('test-token')->plainTextToken;
" 2>/dev/null | grep -o '[0-9]*|[A-Za-z0-9]*' | head -1)

echo ""
echo "=========================================="
echo "Server running at: http://localhost:8000"
echo "  API Base URL: http://localhost:8000/api"
echo "  API Documentation: http://localhost:8000/docs"
echo "  Test Suite: http://localhost:8000/tests"
echo ""
if [ ! -z "$API_TOKEN" ]; then
    echo "API Token (copy and paste into tests.html):"
    echo "  $API_TOKEN"
else
    echo "Warning: Failed to generate API token automatically"
    echo "Generate one manually with:"
    echo "  php artisan tinker"
    echo "  User::first()->createToken('test-token')->plainTextToken"
fi
echo ""
echo "Press Ctrl+C to stop the server"
echo "=========================================="
echo ""

php artisan serve --host=0.0.0.0 --port=8000
