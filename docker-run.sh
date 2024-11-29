#!/bin/bash

echo "Available Docker images:"
# Skip the header line and format the output correctly
docker images | awk 'NR>1 {printf "%s. %s:%s\n", NR-1, $1, $2}'
echo ""

# Read user input for the image number
read -p "Please enter the number of the image to start an interactive shell: " image_num

# Validate user input
if ! [[ "$image_num" =~ ^[0-9]+$ ]]; then
  echo "Error: Please enter a valid number."
  exit 1
fi

# Get the image name and tag based on the user input
image_info=$(docker images | awk "NR==$((image_num + 1)) {print \$1\":\"\$2}")
if [ -z "$image_info" ]; then
  echo "Error: Invalid image number."
  exit 1
fi

# Debug statements to check the values
echo "Image Info: $image_info"

# Split the image_info into name and tag
image_name=${image_info%%:*}
image_tag=${image_info##*:}

# Debug statements to check the split values
echo "Image Name: $image_name"
echo "Image Tag: $image_tag"

# Check if the image exists
if ! docker inspect -f '{{.Config.Image}}' "$image_name:$image_tag" >/dev/null 2>&1; then
  echo "Error: Image '$image_name:$image_tag' not found."
  exit 1
fi

# Check if a container name was provided as an argument
if [ -z "$1" ]; then
  read -p "Please provide a container name or ID to start an interactive shell: " container_name
else
  container_name="$1"
fi

# Sanitize the container name to remove invalid characters
container_name=$(echo "$container_name" | tr '/' '_')  # Replace slashes with underscores
container_name="docker_run_${container_name}_$(date +%Y%m%d%H%M%S)"

# Check if the container exists
if ! docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
  # Run the container in interactive mode
  docker run -d --name "$container_name" "$image_name:$image_tag" /bin/sh -c "while true; do sleep 30; done"
fi

# Start an interactive shell in the container
docker exec -it "$container_name" /bin/bash
