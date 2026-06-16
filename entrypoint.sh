#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /manyoo-rails-task/tmp/pids/server.pid

# Run migrations in production
if [ "$RAILS_ENV" = "production" ]; then
bundle exec rails db:migrate
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"