# NGINX Deployment Scripts

Automated deployment scripts for running the REST API with NGINX and PHP-FPM.

## Prerequisites

- **NGINX** installed
  - macOS: `brew install nginx`
  - Linux: `sudo apt-get install nginx`
- **PHP-FPM** installed (comes with PHP)
  - macOS: `brew install php`
  - Linux: `sudo apt-get install php-fpm`
- **MySQL** running with database setup complete

## Quick Start

### 1. Deploy with NGINX

From the project root directory:

```bash
./deploy/setup_nginx.sh
```

This script will:
- Check for NGINX and PHP-FPM installation
- Auto-detect PHP-FPM socket/port configuration
- Generate NGINX configuration file (`nginx_api.conf`)
- Verify configuration syntax
- Start/restart NGINX and PHP-FPM services
- Test the deployment
- Display access URLs and useful commands

### 2. Access Your API

Once deployed, access your API at:

- **API Documentation**: http://localhost:8000/docs
- **API Tests**: http://localhost:8000/tests
- **API Endpoints**: http://localhost:8000/agents

### 3. Stop NGINX

When you're done:

```bash
./deploy/stop_nginx.sh
```

## Files Generated

After running `setup_nginx.sh`, you'll find:

- `deploy/nginx_api.conf` - NGINX configuration file
- `deploy/nginx_access.log` - Access logs
- `deploy/nginx_error.log` - Error logs

## Troubleshooting

### Check Logs

```bash
# View access logs
tail -f deploy/nginx_access.log

# View error logs
tail -f deploy/nginx_error.log
```

### Verify Services Are Running

```bash
# Check NGINX
ps aux | grep nginx

# Check PHP-FPM
ps aux | grep php-fpm
```

### Test Configuration

```bash
# macOS
nginx -t -c deploy/nginx_api.conf

# Linux
sudo nginx -t -c deploy/nginx_api.conf
```

### Common Issues

**Port 8000 already in use:**
- Stop the PHP built-in server if running: `pkill -f "php -S"`
- Or edit `nginx_api.conf` and change `listen 8000;` to another port
- Restart NGINX

**PHP-FPM socket not found:**
- The script auto-detects common locations
- If it fails, check your PHP-FPM configuration: `php-fpm -i | grep listen`
- Update the socket path in `nginx_api.conf`

**502 Bad Gateway:**
- PHP-FPM is not running. Start it:
  - macOS: `brew services start php`
  - Linux: `sudo systemctl start php-fpm`

## Manual NGINX Control

### macOS

```bash
# Start
nginx -c /path/to/deploy/nginx_api.conf

# Stop
nginx -s quit

# Reload configuration
nginx -s reload
```

### Linux

```bash
# Start
sudo systemctl start nginx

# Stop
sudo systemctl stop nginx

# Restart
sudo systemctl restart nginx

# Reload configuration
sudo systemctl reload nginx
```

## Configuration Details

The generated `nginx_api.conf` includes:

- Listens on port **8000** (same as PHP built-in server)
- Document root points to your `code/` directory
- All requests route through `index.php` (front controller pattern)
- PHP-FPM integration with auto-detected socket
- Security rules (deny access to hidden files and config.php)
- Custom logging to `deploy/` directory

## Production Considerations

For production deployment:

1. Change port to 80 or 443 (with SSL)
2. Add proper server_name (domain)
3. Configure SSL certificates
4. Adjust PHP-FPM pool settings
5. Enable gzip compression
6. Add rate limiting
7. Configure proper log rotation

## Testing the Deployment

The setup script automatically tests:
- NGINX responds on port 8080
- PHP files are processed
- API endpoints are accessible

You can manually test with:

```bash
# Test homepage/docs
curl -I http://localhost:8000/docs

# Test API endpoint
curl http://localhost:8000/agents

# Test with authentication
curl -H "Authorization: Bearer YOUR_TOKEN" \
     http://localhost:8000/agents
```
