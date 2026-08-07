#!/usr/bin/env bash
set -euo pipefail

# install Ruby gems and Node deps (idempotent)
bundle install --jobs 4 --retry 3 || echo "WARNING: bundle install failed"
pnpm install --frozen-lockfile || pnpm install || echo "WARNING: pnpm install failed"

# db setup
DB_FILE="db/development/app.sqlite3"
if [ ! -f "$DB_FILE" ]; then
  echo "DB not found - creating and migrating..."
  bundle exec rake db:create db:migrate
else
  echo "DB exists - migrating"
  bundle exec rake db:migrate
fi

# generate .env file
if [ ! -f .env ]; then
  echo ".env not found, generating it."
  printf "SESSION_SECRET=%s\n" "$(ruby -e 'require "securerandom"; puts SecureRandom.hex(64)')" > .env
  chmod 600 .env
fi
