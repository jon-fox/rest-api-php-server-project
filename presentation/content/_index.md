---
title: 'Agent Management REST API'
date: 2025-11-15
draft: false
---

# Laravel REST API with Docker Deployment

A modern REST API built with Laravel's Eloquent ORM, featuring containerized deployment and comprehensive documentation.

## Key Features

- **Laravel Framework**: Using Eloquent ORM for clean, maintainable database operations
- **Authentication**: Laravel Sanctum-based token authentication
- **Docker Support**: One-command deployment with `setup.sh`
- **Shell Script Deployment**: Traditional deployment with `run.sh`
- **14 API Endpoints**: Complete agent and task management system

## Quick Start

### Docker Deployment
```bash
./setup.sh
```

### Shell Script Deployment
```bash
./run.sh
```

## API Overview

The API manages agents, tasks, tools, and execution logs:

- **7 Public Endpoints** (GET) - No authentication required
- **7 Protected Endpoints** (POST/PUT/DELETE) - Bearer token authentication

### Resources

- **Agents**: Create, read, update, delete, and execute agents
- **Tasks**: Full CRUD operations with status tracking
- **Tools**: List available tools for agents
- **Logs**: Query execution history and debugging info

## Technology Stack

- **Backend**: PHP 8.2+ with Laravel Eloquent ORM
- **Database**: MySQL 8.0
- **Containerization**: Docker & Docker Compose
- **Authentication**: Laravel Sanctum (Bearer tokens)
- **Web Server**: PHP built-in server or NGINX with PHP-FPM

## Project Structure

```
rest-api-php-server-project/
├── code/               # PHP application code
│   ├── models/         # Eloquent models
│   ├── database/       # Schema and migrations
│   └── tests/          # API test suites
├── Dockerfile          # Container definition
├── docker-compose.yml  # Multi-container setup
├── run.sh              # Shell script deployment
└── setup.sh            # Docker deployment
```
