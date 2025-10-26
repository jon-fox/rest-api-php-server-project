#!/bin/bash

# Stop NGINX Deployment Script
# Stops NGINX and PHP-FPM services

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}Stopping NGINX Deployment${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Function to check if running on macOS
is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

# Function to check if running on Linux
is_linux() {
    [[ "$OSTYPE" == "linux-gnu"* ]]
}

# Stop NGINX
if pgrep -x nginx > /dev/null; then
    echo -e "${YELLOW}Stopping NGINX...${NC}"
    if is_macos; then
        nginx -s quit
    elif is_linux; then
        sudo systemctl stop nginx
    fi
    sleep 1
    echo -e "${GREEN}✓ NGINX stopped${NC}"
else
    echo -e "${YELLOW}⚠ NGINX is not running${NC}"
fi

# Optionally stop PHP-FPM (commented out by default)
# Uncomment if you want to stop PHP-FPM too
# if pgrep -x php-fpm > /dev/null; then
#     echo -e "${YELLOW}Stopping PHP-FPM...${NC}"
#     if is_macos; then
#         brew services stop php
#     elif is_linux; then
#         sudo systemctl stop php-fpm
#     fi
#     echo -e "${GREEN}✓ PHP-FPM stopped${NC}"
# fi

echo ""
echo -e "${GREEN}✓ Services stopped${NC}"
echo ""
