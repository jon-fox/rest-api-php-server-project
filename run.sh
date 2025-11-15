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
        echo "✓ Created .env from .env.example"
    else
        cat > .env << 'EOF'
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=agent_management
DB_USER=root
DB_PASS=
EOF
        echo "✓ Created default .env file"
        echo "  Edit code/.env to set your database credentials"
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
    echo "✓ Dependencies installed"
fi

echo ""
echo "Setting up database..."
cd database
if [ -f "setup.sh" ]; then
    bash setup.sh
else
    echo "Warning: database/setup.sh not found, skipping database setup"
fi
cd "$CODE_DIR"

echo ""
echo "Starting PHP development server..."
echo ""
echo "Server running at: http://localhost:8000"
echo "API Documentation: http://localhost:8000/docs"
echo "API Tests: http://localhost:8000/tests"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

php -S localhost:8000
