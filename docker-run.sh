#!/bin/bash

# Display Docker images
echo "Available Docker images:"
docker images
echo ""

# Check if a container name or ID has been provided
if [ -z "$1" ]; then
  echo "Please provide a container name or ID to start an interactive shell:"
  read container_name
else
  container_name="$1"
fi

# Check if the container exists
if ! docker inspect -f '{{.State.Status}}' "$container_name" >/dev/null 2>&1; then
  echo "Error: Container '$container_name' not found."
  exit 1
fi

# Enter the container and start a shell session
docker exec -it "$container_name" /bin/bash
