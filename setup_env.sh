#!/bin/bash

# Check for Conda installation
if ! command -v conda &> /dev/null; then
    echo "Conda is not installed or not in PATH."
    exit 1
fi

# Prompt for Python version
read -p "Enter Python version (e.g., 3.8): " python_version

# Create Conda environment
echo "Creating Conda environment..."
conda create --name myenv python=$python_version -y
if [ $? -ne 0 ]; then
    echo "Failed to create Conda environment. Please check the Python version and try again."
    exit 1
fi

# Activate Conda environment
source activate myenv || {
    echo "Failed to activate the Conda environment."
    exit 1
}

# Create project directories
echo "Creating project directories..."
mkdir -p src tests data docs notebooks

# Copy .env.example to .env
echo "Setting up environment variables..."
if [ -f .env.example ]; then
    cp .env.example .env
else
    echo "Warning: .env.example not found. Please ensure it exists in the root directory."
fi

# Install dependencies from requirements.txt
if [ -f requirements.txt ]; then
    echo "Installing dependencies from requirements.txt..."
    pip install -r requirements.txt || {
        echo "Failed to install dependencies. Check requirements.txt."
        exit 1
    }
else
    echo "Warning: requirements.txt not found. Please ensure it exists in the root directory."
fi

echo "Environment setup complete!"
