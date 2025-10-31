# Default task
default: list

# List available tasks
list:
    @just --list

# --- Local Development ---
up:
    @echo "Bringing up local development environment..."
    docker compose -f compose/monitoring/docker-compose.yml up -d
    docker compose -f compose/llm/docker-compose.yml up -d
    # Add other services as needed

down:
    @echo "Stopping local development environment..."
    docker compose -f compose/monitoring/docker-compose.yml down
    docker compose -f compose/llm/docker-compose.yml down

# --- Database ---
db:migrate:
    @echo "Running database migrations..."
    docker run --rm -v "$(pwd)/db:/db" --network host ghcr.io/amacneil/dbmate:1.17.0 -e DATABASE_URL up

db:new name:
    @echo "Creating new migration: {{name}}"
    docker run --rm -v "$(pwd)/db:/db" ghcr.io/amacneil/dbmate:1.17.0 new {{name}}

# --- CI/CD ---
build:
    @echo "Building all applications..."
    # This would be replaced by path-filtered builds in CI

test:
    @echo "Running all tests..."
