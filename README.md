# Laravel REST API - Agent Management System

A containerized Laravel REST API for managing AI agents, tasks, tools, and logs.

**Tested on:** macOS

## Prerequisites

- Docker or [Colima](https://github.com/abiosoft/colima)
- Bash shell

## Quick Start

### First Time Setup

```bash
bash run.sh
```

This automatically:
- Starts Docker/Colima if needed
- Builds and starts containers (MySQL + Laravel)
- Runs database migrations
- Seeds sample data (agents, tasks, tools)
- Generates API authentication token
- Updates test suite with valid token

### Subsequent Runs

```bash
bash run.sh
```

Detects existing setup and displays connection info. Re-runs seeding and token generation only if needed.

### Manual Setup

If you need to rebuild from scratch:

```bash
bash setup.sh
```

## API Endpoints

- **API Base:** http://localhost:8000/api
- **Documentation:** http://localhost:8000/docs
- **Test Suite:** http://localhost:8000/tests

## Management

**Stop containers:**
```bash
docker compose down
```

**Reset everything:**
```bash
docker compose down -v
bash run.sh
```

## API Resources

- **Agents:** CRUD operations for AI agents
- **Tasks:** Task management with status tracking
- **Tools:** Available tools listing
- **Logs:** Activity logs

Authentication required for POST/PUT/DELETE operations using Bearer token.
