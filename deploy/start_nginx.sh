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

# Hint if .env is missing (PHP reads code/.env, not shell env)
if [ ! -f "$CODE_DIR/.env" ]; then
  echo "Warning: $CODE_DIR/.env not found."
  echo "  Copy code/.env.example to code/.env and set DB_HOST/DB_PORT/DB_NAME/DB_USER/DB_PASS."
fi

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
      # Self-contained FastCGI params (similar to default fastcgi_params)
      fastcgi_param QUERY_STRING        \$query_string;
      fastcgi_param REQUEST_METHOD      \$request_method;
      fastcgi_param CONTENT_TYPE        \$content_type;
      fastcgi_param CONTENT_LENGTH      \$content_length;

      fastcgi_param SCRIPT_NAME         \$fastcgi_script_name;
      fastcgi_param REQUEST_URI         \$request_uri;
      fastcgi_param DOCUMENT_URI        \$document_uri;
      fastcgi_param DOCUMENT_ROOT       \$document_root;
      fastcgi_param SERVER_PROTOCOL     \$server_protocol;

      fastcgi_param REQUEST_SCHEME      \$scheme;
      fastcgi_param HTTPS               \$https if_not_empty;

      fastcgi_param GATEWAY_INTERFACE   CGI/1.1;
      fastcgi_param SERVER_SOFTWARE     nginx/\$nginx_version;

      fastcgi_param REMOTE_ADDR         \$remote_addr;
      fastcgi_param REMOTE_PORT         \$remote_port;
      fastcgi_param SERVER_ADDR         \$server_addr;
      fastcgi_param SERVER_PORT         \$server_port;
      fastcgi_param SERVER_NAME         \$server_name;

      fastcgi_param SCRIPT_FILENAME     \$document_root\$fastcgi_script_name;
      fastcgi_param REDIRECT_STATUS     200;
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

# Ensure MySQL/MariaDB is running on port 3306 (starts it if not)
ensure_mysql() {
  # Already listening?
  if command -v lsof >/dev/null 2>&1; then
    lsof -tiTCP:3306 -sTCP:LISTEN >/dev/null 2>&1 && return 0
  elif command -v ss >/dev/null 2>&1; then
    ss -ltn | grep -q ":3306" && return 0
  fi

  echo "Starting MySQL/MariaDB on :3306 ..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew >/dev/null 2>&1; then
      brew services start mysql@8.0 >/dev/null 2>&1 || \
      brew services start mysql >/dev/null 2>&1 || \
      brew services start mariadb >/dev/null 2>&1 || true
    fi
  else
    if command -v systemctl >/dev/null 2>&1; then
      sudo systemctl start mysql >/dev/null 2>&1 || \
      sudo systemctl start mariadb >/dev/null 2>&1 || \
      sudo systemctl start mysqld >/dev/null 2>&1 || true
    fi
    if command -v service >/dev/null 2>&1; then
      sudo service mysql start >/dev/null 2>&1 || \
      sudo service mariadb start >/dev/null 2>&1 || \
      sudo service mysqld start >/dev/null 2>&1 || true
    fi
  fi
}

# Ensure PHP-FPM is running on 127.0.0.1:9000 (starts it if not)
ensure_php_fpm() {
  # If something is already listening on :9000, we're good
  if command -v lsof >/dev/null 2>&1; then
    if lsof -tiTCP:9000 -sTCP:LISTEN >/dev/null 2>&1; then
      return 0
    fi
  fi
  if command -v ss >/dev/null 2>&1; then
    if ss -ltn | grep -q ":9000"; then
      return 0
    fi
  fi

  echo "Starting PHP-FPM (for fastcgi on 127.0.0.1:9000) ..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew >/dev/null 2>&1; then
      brew services start php >/dev/null 2>&1 || true
    fi
    command -v php-fpm >/dev/null 2>&1 && php-fpm -D >/dev/null 2>&1 || true
  else
    # Try common service managers; ignore failures to keep script simple
    if command -v systemctl >/dev/null 2>&1; then
      sudo systemctl start php-fpm >/dev/null 2>&1 || \
      sudo systemctl start php8.2-fpm >/dev/null 2>&1 || \
      sudo systemctl start php8.1-fpm >/dev/null 2>&1 || \
      sudo systemctl start php8.0-fpm >/dev/null 2>&1 || true
    fi
    if command -v service >/dev/null 2>&1; then
      sudo service php-fpm start >/dev/null 2>&1 || \
      sudo service php8.2-fpm start >/dev/null 2>&1 || \
      sudo service php8.1-fpm start >/dev/null 2>&1 || \
      sudo service php8.0-fpm start >/dev/null 2>&1 || true
    fi
    command -v php-fpm >/dev/null 2>&1 && php-fpm -D >/dev/null 2>&1 || true
  fi
}

# Wait for MySQL to be ready (optional fast check)
wait_for_mysql() {
  if ! command -v mysqladmin >/dev/null 2>&1; then
    return 0
  fi
  for i in 1 2 3 4 5; do
    mysqladmin ping -h 127.0.0.1 >/dev/null 2>&1 && return 0
    sleep 0.5
  done
}

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
ensure_mysql
wait_for_mysql
ensure_php_fpm
nginx -c "$CONF"

echo "NGINX is running. If you see 502, ensure PHP-FPM is running on 127.0.0.1:9000"
echo "Try:"
echo "  macOS:   brew services start php"
echo "  Linux/WSL:   sudo systemctl start php-fpm"
