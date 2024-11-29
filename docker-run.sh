#!/bin/bash

echo ""

# First list all avaliable images 
docker images

echo ""

# Check if a container name or ID has been provided
if [ -z "$1" ]; then
  echo "Please provide a container name or ID"
  exit 1
fi

# Enter the container and start a shell session
docker exec -it $1 /bin/bash
