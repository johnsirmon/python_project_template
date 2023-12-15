#!/bin/bash

# Check for administrative privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "You must run this script as an Administrator."
    echo "Please use 'sudo' to run the script with elevated privileges."
    exit 1
fi

#!/bin/bash

# Explicitly set the Conda path
CONDA_PATH="/home/johnsirmon/miniconda3"

# Check for Conda installation
if [ -d "$CONDA_PATH" ]; then
    export PATH="$CONDA_PATH/bin:$PATH"
else
    echo "Conda is not installed or not in PATH."
    echo "To install Conda, download it from https://www.anaconda.com/products/individual and follow the installation instructions."
    echo "If Conda is installed but not in PATH, you can add it manually."
    echo "To add Conda to PATH, find the Conda install directory and add it to your system's PATH variable."
    echo "Consult the Conda documentation or a system administrator for help on modifying the PATH."
    exit 1
fi

# Continue with the rest of your script
# ...

# Prompt for Python version
read -p "Enter Python version (e.g., 3.8): " PYTHON_VERSION

# Create Conda environment
echo "Creating Conda environment..."
conda create --name myenv python="$PYTHON_VERSION" -y

if [ $? -ne 0 ]; then
    echo "Failed to create Conda environment."
    echo "This might be due to an incorrect Python version or a network issue."
    echo "Please check your Python version and internet connection."
    exit $?
fi

# Activate Conda environment
source activate myenv

if [ $? -ne 0 ]; then
    echo "Failed to activate the Conda environment."
    echo "This might be because the environment was not created correctly."
    exit $?
fi

# Create project directories
echo "Creating project directories..."
mkdir src
mkdir tests
mkdir data
mkdir docs
mkdir notebooks

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
    pip install -r requirements.txt
else
    echo "Warning: requirements.txt not found. Please ensure it exists in the root directory."
fi

echo "Environment setup complete!"
