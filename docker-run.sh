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

# Enter the container and start a shell session
docker exec -it "$container_name" /bin/bash
