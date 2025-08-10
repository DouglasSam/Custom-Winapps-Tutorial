#!/bin/bash

# If you are viewing this on a website change or add ?CPU_CORES=4&RAM_SIZE=4G to modify cpu cores and ram size

set -e  # Exit immediately on error

# # Prompt for Windows credentials instead of hardcoding
# read -p "Enter Windows username: " windowsUsername < /dev/tty
# read -s -p "Enter Windows password: " windowsPassword < /dev/tty
# echo ""

# read -p "Are you sure you want to reboot? (y/n): " confirm < /dev/tty

if docker info &> /dev/null; then
    echo "Docker daemon is running, skipping install"
else
    
    echo "Installing docker to run the virtual machine"
    
    curl -fsSL https://get.docker.com/ | bash
    
    sudo usermod -aG docker "$USER"
    
    echo "Docker has been installed, a restart is required before continuing."
    echo "Please restart than run this script again"
    
    read -p "Are you sure you want to reboot? (y/n): " confirm < /dev/tty
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo "Rebooting..."
        sudo reboot
    else
        echo "Reboot cancelled."
    fi

fi

# Check for Docker Compose v2
if ! docker compose version &> /dev/null; then
    echo "Docker Compose v2 is required. Please install it manually."
    exit 1
fi

echo "WARNING, username and password will not be secure."

read -p "Enter username for the Windows VM: " windowsUsername < /dev/tty
read -s -p "Enter password for the Windows VM: " windowsPassword < /dev/tty
echo ""
# exit
# Setup paths
winapps="$HOME/.config/winapps"
winappsVM="${winapps}/vm/"
confURL="%%URL%%/example-winapps.conf"
cores="%%CPU_CORES%%"
ram="%%RAM_SIZE%%"

# Install dependencies
sudo apt update
sudo apt install -y curl dialog freerdp3-x11 git iproute2 libnotify-bin netcat-openbsd

echo "Creating install directory at $winappsVM"
mkdir -p "$winappsVM"

cd "$winappsVM"

# Download OEM files
mkdir -p oem
curl -fsSL -o oem/Container.reg https://raw.githubusercontent.com/winapps-org/winapps/refs/heads/main/oem/Container.reg
curl -fsSL -o oem/NetProfileCleanup.ps1 https://raw.githubusercontent.com/winapps-org/winapps/refs/heads/main/oem/NetProfileCleanup.ps1
curl -fsSL -o oem/RDPApps.reg https://raw.githubusercontent.com/winapps-org/winapps/refs/heads/main/oem/RDPApps.reg
curl -fsSL -o oem/install.bat https://raw.githubusercontent.com/winapps-org/winapps/refs/heads/main/oem/install.bat
curl -fsSL -o oem/install-office.bat %%URL%%/install-office.bat

#sed -i '/^echo\.$/i curl -fsSL -o office.exe https://go.microsoft.com/fwlink/?linkid=2264705&clcid=0x409&culture=en-us&country=us\noffice.exe' oem/install.bat
# curl -fsSL -o office.exe https://go.microsoft.com/fwlink/?linkid=2264705&clcid=0x409&culture=en-us&country=us
# office.exe

# Download and configure docker-compose
curl -fsSL -o docker-compose.yaml https://raw.githubusercontent.com/winapps-org/winapps/refs/heads/main/compose.yaml

# Modify docker-compose settings
sed -i "s/RAM_SIZE: \"4G\"/RAM_SIZE: \"$ram\"/" docker-compose.yaml
sed -i "s/CPU_CORES: \"4\"/CPU_CORES: \"$cores\"/" docker-compose.yaml
sed -i "s/USERNAME: \"MyWindowsUser\"/USERNAME: \"$windowsUsername\"/" docker-compose.yaml
sed -i "s/PASSWORD: \"MyWindowsPassword\"/PASSWORD: \"$windowsPassword\"/" docker-compose.yaml
sed -i 's/VERSION: "11"/VERSION: "tiny11"/' docker-compose.yaml

# Secure docker-compose file
chown "$USER:$USER" docker-compose.yaml
chmod 600 docker-compose.yaml

# Define aliases
aliases=$(cat <<EOF
# WinApps Docker Compose aliases
winvm-start()     { docker compose --file "$(realpath "$winappsVM/docker-compose.yaml")" start; }
winvm-pause()     { docker compose --file "$(realpath "$winappsVM/docker-compose.yaml")" pause; }
winvm-unpause()   { docker compose --file "$(realpath "$winappsVM/docker-compose.yaml")" unpause; }
winvm-restart()   { docker compose --file "$(realpath "$winappsVM/docker-compose.yaml")" restart; }
winvm-stop()      { docker compose --file "$(realpath "$winappsVM/docker-compose.yaml")" stop; }
winvm-kill()      { docker compose --file "$(realpath "$winappsVM/docker-compose.yaml")" kill; }
winvm-create()    { docker compose --file "$(realpath "$winappsVM/docker-compose.yaml")" up -d; }
winvm-logs()      { docker compose --file "$(realpath "$winappsVM/docker-compose.yaml")" logs -f; }
winvm-rdp()       { xfreerdp3 /v:localhost /u:"$windowsUsername" /p:"$windowsPassword" /cert:tofu; }
winvm-help() {
  cat <<HELP
winvm-start      : Start the Windows VM container
winvm-pause      : Pause the Windows VM container
winvm-unpause    : Unpause the Windows VM container
winvm-restart    : Restart the Windows VM container
winvm-stop       : Stop the Windows VM container
winvm-kill       : Force kill the Windows VM container
winvm-create     : Create and start the Windows VM container in detached mode
winvm-logs       : Show logs for the Windows VM container
winvm-rdp        : Connect to the Windows VM via RDP
winvm-help       : Show this help message
HELP
}
EOF
)

# Detect shell config file
if [ -n "$ZSH_VERSION" ]; then
    shell_config="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    shell_config="$HOME/.bashrc"
else
    echo "Unsupported shell. Please add the aliases manually to your shell config."
    exit 1
fi

# Add aliases if not already present
if grep -q "alias winvm-start=" "$shell_config"; then
    echo "Aliases already exist in $shell_config"
else
    echo "$aliases" | tee -a "$shell_config" > /dev/null
    echo "Aliases added to $shell_config"
fi

# Source shell config if bash
if [ -n "$BASH_VERSION" ]; then
    echo "source \"$HOME/.bashrc\"" > /dev/tty
fi

# Configure winapps
cd "$winapps"
curl -fsSL -o winapps.conf "$confURL"
sed -i "s/RDP_USER=\"MyWindowsUser\"/RDP_USER=\"$windowsUsername\"/" winapps.conf
sed -i "s/RDP_PASS=\"MyWindowsPassword\"/RDP_PASS=\"$windowsPassword\"/" winapps.conf

# Secure winapps.conf
chown "$USER:$USER" winapps.conf
chmod 600 winapps.conf

# delete any old freerdp certificate for localhost
rm -f "$HOME/.config/freerdp/server/localhost_3389.pem"
# Final instructions
echo ""
echo "Setup complete."
echo "To begin using WinApps:"
echo "1. Open a new terminal window (or run 'source ~/.bashrc')."
echo "2. Run 'winvm-create' to start the Windows VM."
echo "3. Once it's running, open http://localhost:8006 in your browser and let Windows install."
echo "   This may take a while."
echo "4. Install office through broswer or run 'winvm-rdp' to connect via RDP."
echo "5. Install win apps using a tutorial"

