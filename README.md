# docker-run
Handy Docker script

## Usage
To use the script, simply provide the name or ID of the Docker image you want to run, along with any additional options or arguments:

./docker-run.sh my_image_name [options] [command]

The script will automatically add the -it flag to run the container in interactive mode, and will also set the container's name to docker_run_{image_name}_{timestamp} to make it easier to identify.

## Options
The following options are supported:

* -p <host_port>:<container_port>: Map a host port to a container port.
* -v <host_path>:<container_path>: Mount a host volume to a container path.
* -e <env_var>=<value>: Set an environment variable in the container.
* --rm: Automatically remove the container when it exits.
* --name <container_name>: Set a custom name for the container.

## Running the script 
1. git clone https://github.com/AmirIqbal1/docker-run
2. chmod +x docker-run.sh
3. ./docker-run.sh [ENTER ARGS]

   
