# This script exports a Docker volume to a specified directory

param(
    [string]$volumeName = "n8n_data",
    [string]$dataPath = ".\n8n_data"
)

# Function to check if Docker is running
function Test-DockerRunning {
    try {
        $null = docker info
        return $true
    }
    catch {
        return $false
    }
}

# Function to check if volume exists
function Test-DockerVolume {
    param([string]$Volume)
    
    $volumeExists = docker volume ls --format "{{.Name}}" | Select-String -Pattern "^$Volume$"
    return $null -ne $volumeExists
}

# Main script
try {
    # Check if Docker is running
    if (-not (Test-DockerRunning)) {
        throw "Docker is not running. Please start Docker and try again."
    }

    # Check if volume exists
    if (-not (Test-DockerVolume -Volume $volumeName)) {
        throw "Docker volume '$volumeName' not found."
    }

    # Create target directory if it doesn't exist
    if (-not (Test-Path $dataPath)) {
        New-Item -ItemType Directory -Path $dataPath -Force
        Write-Host "Created target directory: $dataPath"
    }

    # Get absolute path
    $absolutePath = Resolve-Path $dataPath
    
    # Create temporary container to copy data from volume
    Write-Host "Exporting volume '$volumeName' to '$absolutePath'..."
    
    $containerId = docker create --name "temp_export_$(Get-Random)" -v ${VolumeName}:/source alpine:latest
    
    try {
        # Copy data from volume to host
        docker cp "${containerId}:/source/." $absolutePath
        Write-Host "Volume export completed successfully!"
    }
    catch {
        Write-Error "An error occurred during the volume export process."
    }
    finally {
        # Cleanup: Remove temporary container
        docker rm $containerId
    }
}
catch {
    Write-Error "Error: $_"
    exit 1
}