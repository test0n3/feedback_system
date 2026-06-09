#!/usr/bin/env bash
set -euo pipefail

# db setup
DB_FILE="db/development/app.sqlite3"
if [ ! -f "$DB_FILE" ]; then
  echo "DB not found - creating and migrating..."
  bundle exec rake db:create db:migrate
else echo "DB exists - skipping create/migrate"
  bundle exec rake db:migrate || true
fi