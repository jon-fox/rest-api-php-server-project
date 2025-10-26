#!/bin/bash

DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-}"
DB_HOST="${DB_HOST:-localhost}"
DB_NAME="agent_management"

if [ -z "$DB_PASS" ]; then
    read -sp "Enter MySQL password for $DB_USER: " DB_PASS
    echo
fi

TOKEN=$(openssl rand -hex 32)

read -p "Enter token description (optional): " DESCRIPTION

mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" "$DB_NAME" <<EOF
INSERT INTO api_tokens (token, description) VALUES ('$TOKEN', '$DESCRIPTION');
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "Token created successfully!"
    echo "================================"
    echo "Token: $TOKEN"
    echo "================================"
    echo ""
    echo "Use in requests:"
    echo "Authorization: Bearer $TOKEN"
else
    echo "Error creating token"
    exit 1
fi
