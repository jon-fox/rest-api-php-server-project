#!/bin/bash
# Minimal NGINX starter for this project (macOS/Linux)
# - Generates a self-contained NGINX config pointing to ./code
# - Uses PHP-FPM at 127.0.0.1:9000 by default (works with Homebrew PHP)
# - No external includes or OS-specific paths
# - Does NOT manage services; start/stop PHP-FPM yourself if needed
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODE_DIR="$PROJECT_ROOT/code"
CONF="$PROJECT_ROOT/deploy/nginx_api.conf"
LOG_DIR="$PROJECT_ROOT/deploy"
mkdir -p "$LOG_DIR"
echo "Starting NGINX for REST API"

# Generate config (idempotent)
cat > "$CONF" << EOF
# Auto-generated; edit or re-run script to update

# Full config so we can run: nginx -c $CONF

events {}

http {
  server {
    listen 8000;
    server_name localhost;
    root $CODE_DIR;
    index index.php;

    # Route everything through index.php (front controller)
    location / {
      try_files \$uri /index.php?\$args;
    }

    location ~ \.php$ {
      # Prefer TCP for portability; change to unix:/path/to/php-fpm.sock if desired
      fastcgi_pass 127.0.0.1:9000;
      fastcgi_index index.php;
  # Minimal required params (self-contained)
  fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
  fastcgi_param QUERY_STRING    \$query_string;
  fastcgi_param REQUEST_METHOD  \$request_method;
  fastcgi_param CONTENT_TYPE    \$content_type;
  fastcgi_param CONTENT_LENGTH  \$content_length;
    }

    # Basic hardening
    location ~ /\.
    { deny all; }
  }
}
EOF

# Start nginx with our config
if pgrep -x nginx >/dev/null 2>&1; then
  echo "Restarting NGINX..."
  nginx -s quit 2>/dev/null || true
  sleep 0.5
fi

# Free port 8000 if occupied (be polite but effective)
if command -v lsof >/dev/null 2>&1; then
  PIDS=$(lsof -tiTCP:8000 -sTCP:LISTEN || true)
  if [ -n "$PIDS" ]; then
    echo "Port 8000 in use by: $PIDS — terminating to free the port"
    kill $PIDS 2>/dev/null || true
    sleep 0.3
  fi
fi

echo "Starting NGINX on http://localhost:8000 ..."
nginx -c "$CONF"

echo "NGINX is running. If you see 502, ensure PHP-FPM is running on 127.0.0.1:9000"
echo "Try:"
echo "  macOS:   brew services start php"
echo "  Linux/WSL:   sudo systemctl start php-fpm"
