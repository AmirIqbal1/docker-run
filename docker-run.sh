#!/bin/bash

# Display Docker images in numbered format
echo "Available Docker images:"
docker images | awk '{print NR "." $1 " " $2}'
echo ""

# Prompt the user to select an image by number
echo "Please enter the number of the image to start an interactive shell:"
read image_num

# Extract the image name and tag from the selected image number
image_name=$(echo $image_num | awk -F. '{print $2}')
image_tag=$(echo $image_num | awk -F. '{print $3}')

# If no image number is provided, exit the script
if [ -z "$image_num" ]; then
  echo "No image selected. Exiting..."
  exit 1
fi

# Check if the selected image exists
if ! docker inspect -f '{{.Config.Image}}' "$image_name:$image_tag" >/dev/null 2>&1; then
  echo "Error: Image '$image_name:$image_tag' not found."
  exit 1
fi

# Check if a container name or ID has been provided
if [ -z "$1" ]; then
  echo "Please provide a container name or ID to start an interactive shell:"
  read container_name
else
  container_name="$1"
fi

# Check if the container exists
if ! docker inspect -f '{{.State.Status}}' "$container_name" >/dev/null 2>&1; then
  # If the container does not exist, create a new container based on the selected image
  container_name="docker_run_${image_name}_$(date +%Y%m%d%H%M%S)"
  echo "Creating new container '$container_name' based on image '$image_name:$image_tag'..."
  docker run -d --name "$container_name" "$image_name:$image_tag"
fi

# Enter the container and start a shell session
docker exec -it "$container_name" /bin/bash
