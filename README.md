# Create n8n Container with Existing Data

This project contains scripts to create and run an `n8n` container with existing configuration and database files.

## Prerequisites

- Docker must be installed and running on your machine.
- PowerShell must be installed on your machine.

## Scripts

### `create-volume.ps1`

This script creates a Docker volume and populates it with existing configuration and database files.

#### Parameters

- `volumeName` (string): The name of the Docker volume to create. Default is `n8n_data`.
- `containerName` (string): The name of the temporary container to create. Default is `temp-container`.
- `dataPath` (string): The path to the directory containing the configuration and database files. Default is `.\n8n_data`.

#### Usage

```powershell
.\create-volume.ps1 -volumeName "n8n_data" -containerName "temp-container" -dataPath ".\n8n_data"
```

### `run-container.ps1`

This script runs the n8n container with the specified volume and port mapping.

#### Parameters

- `containerName` (string): The name of the container to run. Default is `n8n`.
- `port` (int): The port to map to the container. Default is `5678`.
- `volumeName` (string): The name of the Docker volume to use. Default is `n8n_data`.

#### Usage

```powershell
.\run_container.ps1 -containerName "n8n" -port 5678 -volumeName "n8n_data"
```
