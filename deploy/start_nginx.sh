#!/bin/bash

# Start NGINX with PHP-FPM for REST API

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODE_DIR="$PROJECT_ROOT/code"
DEPLOY_DIR="$PROJECT_ROOT/deploy"
NGINX_CONFIG="$DEPLOY_DIR/nginx_api.conf"

echo -e "${BLUE}Starting REST API with NGINX${NC}"
echo ""

# Check if config exists, generate if needed
if [ ! -f "$NGINX_CONFIG" ]; then
    echo -e "${YELLOW}Generating NGINX configuration...${NC}"
    
    # Detect PHP-FPM socket
    if [[ "$OSTYPE" == "darwin"* ]]; then
        PHP_FPM_SOCK="/opt/homebrew/var/run/php-fpm.sock"
        [ ! -S "$PHP_FPM_SOCK" ] && PHP_FPM_SOCK="/usr/local/var/run/php-fpm.sock"
        [ ! -S "$PHP_FPM_SOCK" ] && PHP_FPM_SOCK="127.0.0.1:9000"
    else
        PHP_FPM_SOCK="/run/php/php-fpm.sock"
        [ ! -S "$PHP_FPM_SOCK" ] && PHP_FPM_SOCK="/var/run/php-fpm.sock"
        [ ! -S "$PHP_FPM_SOCK" ] && PHP_FPM_SOCK="127.0.0.1:9000"
    fi
    
    cat > "$NGINX_CONFIG" << EOFCONFIG
server {
    listen 8000;
    server_name localhost;
    root $CODE_DIR;
    index index.php;
    
    access_log $DEPLOY_DIR/nginx_access.log;
    error_log $DEPLOY_DIR/nginx_error.log;
    
    location / {
        try_files \$uri /index.php\$is_args\$args;
    }
    
    location ~ \.php$ {
        fastcgi_pass unix:$PHP_FPM_SOCK;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_read_timeout 300;
    }
    
    location ~ /\. {
        deny all;
    }
}
EOFCONFIG
    echo -e "${GREEN}✓ Configuration generated${NC}"
fi

# Start PHP-FPM if needed
if ! pgrep -x php-fpm > /dev/null; then
    echo -e "${YELLOW}Starting PHP-FPM...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew services start php 2>/dev/null || php-fpm -D
    else
        sudo systemctl start php-fpm
    fi
    sleep 2
    echo -e "${GREEN}✓ PHP-FPM started${NC}"
else
    echo -e "${GREEN}✓ PHP-FPM already running${NC}"
fi

# Start NGINX
echo -e "${YELLOW}Starting NGINX...${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    nginx -s quit 2>/dev/null || true
    sleep 1
    nginx -c "$NGINX_CONFIG"
else
    sudo cp "$NGINX_CONFIG" /etc/nginx/sites-available/rest-api
    sudo ln -sf /etc/nginx/sites-available/rest-api /etc/nginx/sites-enabled/rest-api
    sudo systemctl restart nginx
fi

sleep 2

# Quick test
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8000 | grep -q "200"; then
    echo -e "${GREEN}✓ NGINX started successfully${NC}"
    echo ""
    echo -e "${GREEN}API available at: http://localhost:8000${NC}"
    echo -e "  • Docs: http://localhost:8000/docs"
    echo -e "  • Tests: http://localhost:8000/tests"
else
    echo -e "${RED}✗ NGINX may not be responding${NC}"
    echo "Check: tail -f $DEPLOY_DIR/nginx_error.log"
fi
