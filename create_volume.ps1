# This script creates an n8n volume and populates it with existing config and database files

param (
    [string]${volumeName} = "n8n_data",
    [string]${containerName} = "temp-container",
    [string]${dataPath} = ".\n8n_data"
)

# Function to check if Docker is installed and running
function Test-Docker {
    try {
        docker info > $null 2>&1
        return $true
    }
    catch {
        return $false
    }
}

if (-not (Test-Docker)) {
    Write-Error "Docker is not installed or running. Please install and start Docker."
    exit 1
}

try {
    # Create the Docker volume
    docker volume create ${volumeName}

    # Create a temporary container to add files to the volume
    docker run -d --name ${containerName} -v ${volumeName}:/data alpine:latest tail -f /dev/null

    # Create necessary directory structure
    docker exec ${containerName} mkdir -p /data/

    # Copy your config and database files to the temporary container
    docker cp ${dataPath}/. ${containerName}:/data/

    # Fix permissions (n8n runs as user with UID 1000)
    docker exec ${containerName} chown -R 1000:1000 /data/
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    # Clean up - stop and remove the temporary container
    docker stop ${containerName}
    docker rm ${containerName}
}