# Database Structure

## Overview

MySQL database for AI agent management system with task tracking, tool registry, and execution logging.

## Setup

Use TCP settings that match `code/.env` (local defaults):

```bash
DB_HOST=127.0.0.1 DB_PORT=3306 DB_USER=root DB_PASS=123456 ./setup.sh
```

Prompts for MySQL credentials and optionally loads seed data.

## Tables

**agents** - AI agent instances
- Tracks agent name, description, and current status
- Status: idle, running, paused, error

**tasks** - Work assignments for agents
- Links to agent via foreign key
- Status: pending, running, completed, failed
- Priority field for task ordering

**tools** - Available tools agents can use
- Tool registry with name, description, category
- Referenced by agents during execution

**logs** - Execution history and debugging
- Links to both agent and task
- Log levels: info, warning, error, debug
- Timestamped for audit trail

**api_tokens** - Bearer token authentication
- Secure endpoints require valid token
- Supports expiration dates

## Indexes

- Status fields (agents, tasks)
- Foreign keys (agent_id, task_id)
- Log timestamps for efficient queries
