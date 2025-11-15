#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

[ ! -f "code/.env" ] && cat > code/.env << 'EOF'
DB_HOST=mysql
DB_NAME=agent_management
DB_USER=root
DB_PASS=secret
EOF

echo "Building and starting containers..."
docker compose up -d --build

echo "Waiting for MySQL..."
sleep 5

echo "Installing dependencies..."
docker compose exec app composer install --no-interaction --optimize-autoloader

echo ""
echo "API running at http://localhost:8000"
echo "  Docs: http://localhost:8000/docs"
echo ""
