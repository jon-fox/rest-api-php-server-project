---
marp: true
paginate: true
size: 16:9
---

# Stage 1 REST API — Quick Guide

- PHP + MySQL backend with 14 endpoints (7 protected)
- Run locally via PHP built-in or NGINX script
- Includes docs page and two test suites

---

## Agent State Controller

- Manages agent lifecycle: idle, running, paused, error
- CRUD for agents, tasks, tools; logs for execution history
- Bearer token auth for mutating operations
- Front controller via PHP (built-in) or NGINX + PHP-FPM
- Docs page and two test suites included

---
 

## Prerequisites

- PHP 8+, MySQL (or MariaDB)
- (Optional) NGINX + PHP-FPM
- VS Code (for editing), curl (for tests)

 ---

## Endpoints Overview

- Agents: list, get, create, update, delete
- Tasks: list, get, create, update, delete
- Tools: list, create
- Logs: list

---

## Protected Endpoints (Bearer)

- POST/PUT/DELETE for Agents and Tasks
- POST Tools, Logs write endpoints
- Provide header: `Authorization: Bearer <token>`

---

## Sample Request (Protected)

Create Agent:

```bash
curl -X POST http://localhost:8000/agents \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"DemoAgent","description":"test"}'
```

---

## Sample Response

```json
{ "id": 1, "name": "DemoAgent", "status": "idle" }
```

---

## NGINX Config Anatomy

- listen 8000; root code/
- `try_files $uri /index.php?$args`
- fastcgi_pass 127.0.0.1:9000
- minimal, self-contained config

---

## PHP-FPM Quick Start

- macOS: `brew services start php`
- Linux/WSL: `sudo systemctl start php-fpm`
- Script auto-starts if not running

---

## Windows / WSL Note

- Recommended: WSL (Ubuntu) then follow Linux steps
- Native: nginx.exe + php-cgi.exe (not primary path)

---

## Schema Overview

- agents, tasks, tools, logs, api_tokens
- Foreign keys: tasks→agents, logs→(agents,tasks)
- Indexes on status and timestamps

---

## Seed Data (Optional)

- `./setup.sh` prompts to load seed.sql
- Provides sample agents/tasks/tools/logs

---

## 1) Configure Database (.env)

Create `code/.env`:

```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=agent_management
DB_USER=root
DB_PASS=123456
```

Tip: Keep this file local. Values above are for local dev only.

<div align="center">
  <img src="screenshots/env-file.png" height="200" />
</div>

---

## 2) Initialize Database

From `code/database/`:

```bash
DB_HOST=127.0.0.1 DB_PORT=3306 DB_USER=root DB_PASS=123456 ./setup.sh
```

- Creates DB and tables, optional seed data

<div align="center">
  <img src="screenshots/db-setup.png" height="200" />
</div>

---

## 3) Start Server (PHP built-in)

<table>
  <tr>
    <td width="35%" valign="top">
      <p><strong>From <code>code/</code>:</strong></p>
      <pre><code>php -S localhost:8000</code></pre>
      <p><strong>Visit:</strong></p>
      <ul>
        <li>http://localhost:8000/docs</li>
      </ul>
    </td>
    <td width="60%" align="right" valign="middle" style="padding-left: 24px;">
      <img src="screenshots/php-direct-start.png" height="240" />
    </td>
  </tr>
  
</table>

---

## 4) Start Server (NGINX script)

<table>
  <tr>
    <td width="55%" valign="top">
      <p><strong>From project root:</strong></p>
      <pre><code>./deploy/start_nginx.sh</code></pre>
      <ul>
        <li>Auto-generates config, starts services if needed</li>
        <li>Visit http://localhost:8000/docs</li>
      </ul>
      <p><strong>Stop:</strong></p>
      <pre><code>./deploy/stop_nginx.sh</code></pre>
    </td>
    <td width="45%" align="right" valign="middle" style="padding-left: 24px;">
      <div><img src="screenshots/nginx-start.png" height="160" /></div>
      <div style="margin-top: 12px;"><img src="screenshots/nginx-stop.png" height="160" /></div>
    </td>
  </tr>
</table>

---

## 5) Generate Auth Token

From `code/`:

```bash
./generate_token.sh
```

- Inserts token into DB
- Use “Authorization: Bearer <token>” in protected calls

<div align="center">
  <img src="screenshots/token-generated.png" height="200" />
</div>

---

## 6) Test — Shell Suite

From `code/`:

```bash
./tests/test_api.sh
```

- Runs cURL tests against all endpoints
- Shows HTTP codes and pass/fail

<table>
  <tr>
    <td align="center">
      <img src="screenshots/tests-curl.png" height="200" />
      <div><strong>cURL run</strong></div>
    </td>
    <td align="center">
      <img src="screenshots/tests-shell-database.png" height="200" />
      <div><strong>DB verification</strong></div>
    </td>
  </tr>
</table>

---

## 7) Test — Browser Suite

Open:

```bash
open code/tests/test.html       # macOS
# or
xdg-open code/tests/test.html   # Linux
```

- Click “Run All Tests”
- See per-endpoint results

<div align="center">
  <img src="screenshots/tests-browser.png" height="200" />
</div>

---

## 8) Docs Page

<table>
  <tr>
    <td width="55%" valign="top">
      <ul>
        <li>http://localhost:8000/docs</li>
        <li>Try endpoints interactively</li>
        <li>Paste the Bearer token for protected routes</li>
      </ul>
    </td>
    <td width="45%" align="right" valign="middle">
      <img src="screenshots/swagger-docs.png" height="340" />
    </td>
  </tr>
</table>

---

## 9) Troubleshooting (Quick)

- DB errors: check `code/.env` values
- 502 in NGINX: ensure PHP-FPM is running
  - macOS: `brew services start php`
  - Linux/WSL: `sudo systemctl start php-fpm`
- Port busy: script frees 8000 automatically

---

## 10) What’s Included

- REST API (PHP) with MySQL (PDO)
- Auth via `api_tokens` table
- `./deploy/start_nginx.sh` + `./deploy/stop_nginx.sh`
- Docs page + two test suites

---

## DB Troubleshooting

- Access denied: check `DB_USER/DB_PASS`
- Unknown DB: run setup.sh
- Not running: start MySQL (brew/systemctl)

---

## Ports & Tips

- Default port: 8000 (script frees if busy)
- Use `php -S` for quick dev, NGINX for parity
