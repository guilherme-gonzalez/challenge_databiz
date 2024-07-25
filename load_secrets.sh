#!/bin/bash

# Install yq if not already installed
if ! command -v yq &> /dev/null; then
    echo "yq could not be found. Installing yq..."
    pip install yq
fi

# Load secrets from secrets.yaml
export _AIRFLOW_WWW_USER_USERNAME=$(yq eval '.airflow.username' secrets.yaml)
export _AIRFLOW_WWW_USER_PASSWORD=$(yq eval '.airflow.password' secrets.yaml)

# Start Docker Compose with exported variables
docker-compose up -d
