#!/bin/bash

DB_USER="${DB_USER:-root}"
DB_HOST="${DB_HOST:-localhost}"
DB_NAME="agent_management"

if [ -n "$MYSQL_PWD" ]; then
    DB_PASS="$MYSQL_PWD"
elif [ -n "$DB_PASS" ]; then
    DB_PASS="$DB_PASS"
else
    read -sp "Enter MySQL password for $DB_USER: " DB_PASS
    echo
fi

export MYSQL_PWD="$DB_PASS"

echo "Testing database: $DB_NAME"
echo "================================"

mysql -u"$DB_USER" -h"$DB_HOST" "$DB_NAME" <<EOF

SELECT 'Agents:' as '';
SELECT id, name, status FROM agents;

SELECT 'Tasks:' as '';
SELECT id, agent_id, title, status FROM tasks;

SELECT 'Tools:' as '';
SELECT id, name, category FROM tools;

SELECT 'Logs:' as '';
SELECT id, agent_id, level, message FROM logs LIMIT 5;

SELECT 'API Tokens:' as '';
SELECT id, token, description FROM api_tokens;

SELECT 'Table Counts:' as '';
SELECT 
    (SELECT COUNT(*) FROM agents) as agents,
    (SELECT COUNT(*) FROM tasks) as tasks,
    (SELECT COUNT(*) FROM tools) as tools,
    (SELECT COUNT(*) FROM logs) as logs,
    (SELECT COUNT(*) FROM api_tokens) as tokens;

EOF

if [ $? -eq 0 ]; then
    echo "================================"
    echo "Database test completed successfully"
else
    echo "Error querying database"
    exit 1
fi
