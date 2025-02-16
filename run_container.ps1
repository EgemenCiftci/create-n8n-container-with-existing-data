# This script runs the n8n container with the specified volume and port mapping

param (
    [string]${containerName} = "n8n",
    [int]${port} = 5678,
    [string]${volumeName} = "n8n_data"
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
    # Run the n8n container with the specified volume and port mapping
    docker run -it --name ${containerName} -p ${port}:5678 -v ${volumeName}:/home/node/.n8n docker.n8n.io/n8nio/n8n
}
catch {
    Write-Error "An error occurred while running the n8n container: $_"
}