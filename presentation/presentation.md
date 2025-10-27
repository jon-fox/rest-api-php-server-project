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

## API Endpoints Summary

**14 Total Endpoints:**
- 7 Public (GET) - no auth required
- 7 Protected - require Bearer token

**Resources:**
- Agents (5 endpoints)
- Tasks (6 endpoints)
- Tools (1 endpoint)
- Logs (1 endpoint)

---

## 1. GET /agents

**Purpose:** List all agents with their status and details  
**Auth:** None  
**Response:** Array of agent objects

```json
[
  {
    "id": 1,
    "name": "DataCollector",
    "description": "Collects and processes data from various sources",
    "status": "idle",
    "created_at": "2025-10-26 22:06:58",
    "updated_at": "2025-10-26 22:06:58"
  }
  // ... more agents
]
```

---

## 2. GET /agents/{id}

**Purpose:** Get specific agent by ID  
**Auth:** None  
**Parameters:** `id` (path, integer)  
**Response:** Agent object or 404

```json
{
  "id": 1,
  "name": "DataCollector",
  "description": "Collects and processes data from various sources",
  "status": "idle",
  "created_at": "2025-10-26 22:06:58",
  "updated_at": "2025-10-26 22:06:58"
}
```

---

## 3. POST /agents 🔒

**Purpose:** Create a new agent  
**Auth:** Bearer token required  
**Body:**
```json
{
  "name": "NewAgent",
  "description": "Test agent"
}
```

**Response (201):**
```json
{
  "id": "4",
  "message": "Agent created"
}
```

---

## 4. PUT /agents/{id} 🔒

**Purpose:** Update agent details  
**Auth:** Bearer token required  
**Parameters:** `id` (path)  
**Body:** Partial update allowed
```json
{
  "status": "paused"
}
```

**Response:**
```json
{
  "message": "Agent updated"
}
```

---

## 5. DELETE /agents/{id} 🔒

**Purpose:** Delete agent (cascades to tasks/logs)  
**Auth:** Bearer token required  
**Parameters:** `id` (path, integer)

**Response:**
```json
{
  "message": "Agent deleted"
}
```

**Note:** All related tasks and logs are also deleted

---

## 6. POST /agents/{id}/execute 🔒

**Purpose:** Execute an agent and log the action  
**Auth:** Bearer token required  
**Parameters:** `id` (path)  
**Effect:** Sets status to "running", logs execution start

**Response:**
```json
{
  "message": "Agent execution started",
  "agent_id": "2"
}
```

---

## 7. GET /tasks

**Purpose:** List all tasks ordered by priority  
**Auth:** None  
**Response:** Array of task objects

```json
[
  {
    "id": 4,
    "agent_id": 3,
    "title": "Check system status",
    "description": "Monitor CPU and memory usage",
    "status": "running",
    "priority": 3,
    "created_at": "2025-10-26 22:06:58",
    "updated_at": "2025-10-26 22:06:58"
  },
  //.... other agent tasks
]
```

---

## 8. GET /tasks/{id}

**Purpose:** Get specific task by ID  
**Auth:** None  
**Parameters:** `id` (path, integer)  
**Response:** Task object or 404

```json
{
  "id": 1,
  "agent_id": 1,
  "title": "Fetch weather data",
  "description": "Collect weather information from API",
  "status": "pending",
  "priority": 1,
  "created_at": "2025-10-26 22:06:58",
  "updated_at": "2025-10-26 22:06:58"
}
```

---

## 9. GET /tasks/{id}/status

**Purpose:** Get current status of a task (lightweight)  
**Auth:** None  
**Parameters:** `id` (path, integer)

**Response:**
```json
{
  "task_id": 1,
  "status": "pending"
}
```

**Use case:** Polling for status updates

---

## 10. POST /tasks 🔒

**Purpose:** Create a new task  
**Auth:** Bearer token required  
**Body:**
```json
{
  "title": "New Task",
  "agent_id": 2,
  "priority": 5
}
```

**Response (201):**
```json
{
  "id": "5",
  "message": "Task created"
}
```

---

## 11. PUT /tasks/{id} 🔒

**Purpose:** Update task details  
**Auth:** Bearer token required  
**Parameters:** `id` (path)  
**Body:** Partial update allowed
```json
{
  "status": "completed"
}
```

**Response:**
```json
{
  "message": "Task updated"
}
```

---

## 12. DELETE /tasks/{id} 🔒

**Purpose:** Delete task  
**Auth:** Bearer token required  
**Parameters:** `id` (path, integer)

**Response:**
```json
{
  "message": "Task deleted"
}
```

---

## 13. GET /tools

**Purpose:** List all available tools for agents  
**Auth:** None  
**Response:** Array of tool objects (sorted by category, name)

```json
[
  {
    "id": 5,
    "name": "Email Sender",
    "description": "Sends email notifications",
    "category": "communication",
    "created_at": "2025-10-26 22:06:58"
  },
  // .. other agent tools
]
```

---

## 14. GET /logs

<table>
  <tr>
    <td width="45%" valign="top">
      <p><strong>Purpose:</strong> Get execution logs</p>
      <p><strong>Auth:</strong> None</p>
      <p><strong>Query Parameters:</strong></p>
      <ul>
        <li><code>limit</code> (integer, default 100) - Max results</li>
        <li><code>agent_id</code> (integer, optional) - Filter by agent</li>
      </ul>
    </td>
    <td width="55%" valign="top">
      <p><strong>Response:</strong></p>
      <pre><code>{
  "id": 1,
  "agent_id": 1,
  "task_id": 1,
  "level": "info",
  "message": "Task started successfully",
  "created_at": "2025-10-26 22:06:58"
}
// ... more logs</code></pre>
    </td>
  </tr>
</table>

---

## Authentication Example

Protected endpoints require Bearer token:

```bash
curl -X POST http://localhost:8000/agents \
  -H "Authorization: Bearer test_token_12345abcdef67890" \
  -H "Content-Type: application/json" \
  -d '{"name":"NewAgent","description":"Test agent"}'
```

**Generate token:**
```bash
cd code && ./generate_token.sh
```

---

## Error Responses

All endpoints return consistent error format:

```json
{
  "error": "Agent not found"
}
```

**HTTP Status Codes:**
- 200 OK, 201 Created
- 400 Bad Request, 401 Unauthorized, 404 Not Found
- 405 Method Not Allowed, 500 Internal Server Error

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
