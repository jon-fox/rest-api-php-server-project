#!/bin/bash

DB_USER="${DB_USER:-root}"
DB_HOST="${DB_HOST:-localhost}"

if [ -n "$MYSQL_PWD" ]; then
    DB_PASS="$MYSQL_PWD"
elif [ -n "$DB_PASS" ]; then
    DB_PASS="$DB_PASS"
else
    read -sp "Enter MySQL password for $DB_USER: " DB_PASS
    echo
fi

export MYSQL_PWD="$DB_PASS"

echo "Creating database and tables..."
mysql -u"$DB_USER" -h"$DB_HOST" < schema.sql

if [ $? -eq 0 ]; then
    echo "Database schema created successfully"
    
    read -p "Load seed data? (y/n): " LOAD_SEED
    if [ "$LOAD_SEED" = "y" ]; then
        mysql -u"$DB_USER" -h"$DB_HOST" < seed.sql
        echo "Seed data loaded successfully"
    fi
else
    echo "Error creating database"
    exit 1
fi
