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

echo ""
echo "✅ Setup completed successfully!"
echo "API running at http://localhost:8000"
echo "  Docs: http://localhost:8000/docs"
echo "  API base: http://localhost:8000/api"
echo ""
echo "To stop: docker compose down"
echo ""
