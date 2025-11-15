---
title: 'API Documentation'
date: 2025-11-15
draft: false
---

# REST API Documentation

Complete API reference for the Agent Management System.

## Authentication

Protected endpoints require Bearer token authentication:

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8000/api/agents
```

Generate a token:
```bash
cd code && ./generate_token.sh
```

## Endpoints Overview

### Agents

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/agents` | No | List all agents |
| GET | `/agents/{id}` | No | Get agent by ID |
| POST | `/agents` | Yes | Create new agent |
| PUT | `/agents/{id}` | Yes | Update agent |
| DELETE | `/agents/{id}` | Yes | Delete agent |
| POST | `/agents/{id}/execute` | Yes | Execute agent |

### Tasks

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/tasks` | No | List all tasks |
| GET | `/tasks/{id}` | No | Get task by ID |
| GET | `/tasks/{id}/status` | No | Get task status |
| POST | `/tasks` | Yes | Create new task |
| PUT | `/tasks/{id}` | Yes | Update task |
| DELETE | `/tasks/{id}` | Yes | Delete task |

### Tools & Logs

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/tools` | No | List available tools |
| GET | `/logs` | No | Query execution logs |

## Agent Endpoints

### GET /agents

List all agents with their current status.

**Response:**
```json
[
  {
    "id": 1,
    "name": "DataCollector",
    "description": "Collects data from various sources",
    "status": "idle",
    "created_at": "2025-11-15 10:00:00",
    "updated_at": "2025-11-15 10:00:00"
  }
]
```

### POST /agents 🔒

Create a new agent. Requires authentication.

**Request Body:**
```json
{
  "name": "NewAgent",
  "description": "Agent description",
  "status": "idle"
}
```

**Response (201):**
```json
{
  "id": 4,
  "message": "Agent created"
}
```

### POST /agents/{id}/execute 🔒

Execute an agent and log the action.

**Response:**
```json
{
  "message": "Agent execution started",
  "agent_id": 2
}
```

## Task Endpoints

### GET /tasks

List all tasks ordered by priority.

**Response:**
```json
[
  {
    "id": 1,
    "agent_id": 1,
    "title": "Fetch weather data",
    "description": "Collect weather information",
    "status": "pending",
    "priority": 1,
    "created_at": "2025-11-15 10:00:00",
    "updated_at": "2025-11-15 10:00:00"
  }
]
```

### POST /tasks 🔒

Create a new task for an agent.

**Request Body:**
```json
{
  "title": "New Task",
  "agent_id": 2,
  "description": "Task description",
  "priority": 5,
  "status": "pending"
}
```

## Error Responses

All endpoints return consistent error format:

```json
{
  "error": "Error description"
}
```

**HTTP Status Codes:**
- 200 OK
- 201 Created
- 400 Bad Request
- 401 Unauthorized
- 404 Not Found
- 405 Method Not Allowed
- 500 Internal Server Error

## Database Schema

### Agents Table
- `id` (INT, PRIMARY KEY)
- `name` (VARCHAR 255)
- `description` (TEXT)
- `status` (ENUM: idle, running, paused, error)
- `created_at`, `updated_at` (TIMESTAMP)

### Tasks Table
- `id` (INT, PRIMARY KEY)
- `agent_id` (INT, FOREIGN KEY)
- `title` (VARCHAR 255)
- `description` (TEXT)
- `status` (ENUM: pending, running, completed, failed)
- `priority` (INT)
- `created_at`, `updated_at` (TIMESTAMP)

## Testing

### Shell Test Suite
```bash
cd code && ./tests/test_api.sh
```

### Browser Test Suite
Open `code/tests/test.html` in your browser and click "Run All Tests".

## Deployment

### Docker
```bash
./setup.sh
```

### Shell Script
```bash
./run.sh
```

### NGINX
```bash
./deploy/start_nginx.sh
```
