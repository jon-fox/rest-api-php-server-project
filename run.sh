#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODE_DIR="$PROJECT_ROOT/code"

echo "=== Laravel REST API - One-Command Deployment ==="
echo ""

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
    echo ""
    echo "Installing Composer dependencies..."
    if ! command -v composer &> /dev/null; then
        echo "Error: Composer not found. Install from https://getcomposer.org/"
        exit 1
    fi
    composer install --no-interaction --prefer-dist --optimize-autoloader
    echo "Dependencies installed"
fi

echo ""
echo "Generating application key..."
if grep -q "APP_KEY=$" .env || ! grep -q "APP_KEY=" .env; then
    php artisan key:generate --ansi
    echo "Application key generated"
else
    echo "Application key already set"
fi

echo ""
echo "Checking database connection..."
DB_PASSWORD=$(grep "^DB_PASSWORD=" .env | cut -d'=' -f2)
if [ -z "$DB_PASSWORD" ]; then
    read -sp "Enter MySQL root password: " DB_PASSWORD
    echo ""
    # Update .env with password
    if grep -q "^DB_PASSWORD=" .env; then
        sed -i '' "s/^DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" .env
    else
        echo "DB_PASSWORD=$DB_PASSWORD" >> .env
    fi
fi

echo ""
echo "Running database migrations..."
php artisan migrate:fresh --force
echo "Database migrations completed"

echo ""
echo "Seeding database with sample data..."
mysql -u root -h 127.0.0.1 agent_management < "$PROJECT_ROOT/code-original/database/seed.sql" 2>/dev/null || echo "Note: Database seeding skipped (manual seed required)"

echo ""
echo "Starting Laravel development server..."
echo ""
echo "Server running at: http://localhost:8000"
echo "API Base URL: http://localhost:8000/api"
echo "API Documentation: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

php artisan serve --host=0.0.0.0 --port=8000
