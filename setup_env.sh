@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Check for Conda installation
conda --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Conda is not installed or not in PATH.
    exit /b 1
)

REM Prompt for Python version
SET /P PYTHON_VERSION="Enter Python version (e.g., 3.8): "

REM Create Conda environment
echo Creating Conda environment...
conda create --name myenv python=%PYTHON_VERSION% -y
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%

REM Activate Conda environment
CALL activate myenv

REM Create project directories
echo Creating project directories...
mkdir src
mkdir tests
mkdir data
mkdir docs
mkdir notebooks

REM Copy .env.example to .env
echo Setting up environment variables...
IF EXIST .env.example (
    COPY .env.example .env
) ELSE (
    echo Warning: .env.example not found. Please ensure it exists in the root directory.
)

REM Install dependencies from requirements.txt
IF EXIST requirements.txt (
    echo Installing dependencies from requirements.txt...
    pip install -r requirements.txt
) ELSE (
    echo Warning: requirements.txt not found. Please ensure it exists in the root directory.
)

echo Environment setup complete!
ENDLOCAL
