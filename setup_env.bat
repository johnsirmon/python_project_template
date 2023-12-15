REM "@echo off" turns off the command echo, so commands are not shown in the output.
REM "SETLOCAL ENABLEDELAYEDEXPANSION" enables delayed expansion mode, allowing the use of variables within loops.
@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM This part of the script checks if you have administrative rights.
REM "net session" is a command that can only be run successfully by an administrator.
REM ">nul 2>&1" hides any output or errors from the "net session" command.
REM "if %errorlevel% neq 0" checks if the last command (net session) failed (which it does if you're not an admin).
REM If you are not an admin, it shows a message explaining you need to run the script as an Administrator.
REM It then stops the script ("exit /b 1") because it needs admin rights to continue.
REM Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo You must run this script as an Administrator.
    echo Right-click the script and choose "Run as administrator".
    exit /b 1
)

REM Check for Conda installation
REM Conda is a package manager and environment management system for Python.
REM It helps in installing different versions of Python and managing dependencies.
REM The command "conda --version" checks if Conda is installed and accessible.
REM If Conda is installed but the command fails, it might not be added to your PATH environment variable.
REM The PATH environment variable is a system variable that lists directories where the system looks for executable files.
REM If Conda is not in PATH, the system can't find it just by typing "conda" in the command prompt.
conda --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Conda is not installed or not in PATH.
    echo To install Conda, download it from https://www.anaconda.com/products/individual and follow the installation instructions.
    echo If Conda is installed but not in PATH, you can add it manually.
    echo To add Conda to PATH, find the Conda install directory and add it to your system's PATH variable.
    echo Consult the Conda documentation or a system administrator for help on modifying the PATH.
    exit /b 1
)


REM Prompt for Python version
REM Before running this script, you should decide which Python version you need.
REM To check the Python versions available on Conda, you can use the command "conda search python".
REM It's important to choose a version that is compatible with your project's requirements.
REM Generally, it's recommended to use a stable release. For example, as of my last update, Python 3.8 or 3.9 are good choices for most projects.
REM Use a specific version number rather than a generic one to ensure consistency across different environments.
REM After determining the appropriate Python version, enter it when prompted by the script.
SET /P PYTHON_VERSION="Enter Python version (e.g., 3.8): "

REM Create Conda environment
echo Creating Conda environment...
conda create --name myenv python=%PYTHON_VERSION% -y
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to create Conda environment.
    echo This might be due to an incorrect Python version or a network issue.
    echo Please check your Python version and internet connection.
    EXIT /b %ERRORLEVEL%
)

REM Activate Conda environment
CALL activate myenv
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to activate the Conda environment.
    echo This might be because the environment was not created correctly.
    EXIT /b %ERRORLEVEL%
)

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

