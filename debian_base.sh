#!/bin/bash

# Function to check if a command was successful
check_success() {
    if [ $? -ne 0 ]; then
        echo "Erro: $1 falhou."
        exit 1
    fi
}

# system upgrade
echo "System upgrade..."
sudo apt update && sudo apt upgrade -y
check_success "Updated System"

# git install
install_git() {
    echo "Installing git..."
    sudo apt install -y git
    check_success "Git installed"
}

# Customize dock
customize_dock() {
    echo "Customizing Dock..."
    sudo apt install -y dconf-editor
    check_success "Installing dconf-editor..."
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
    check_success "Dock customization"
}

# Brave browser install
install_brave() {
    echo "Installing Brave Browser..."
    sudo apt install -y curl
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
    check_success "Brave Browser installed"
}

install_vscode() { 
    echo "Installing vscode..."
    sudo apt install -y software-properties-common apt-transport-https wget
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install -y code
    check_success "Vscode installed"
}

#install discord
install_discord() {
    echo "Installing Discord..."
    wget -O ~/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo dpkg -i ~/discord.deb
    sudo apt install -f -y
    check_success "Discord installed"
}

# Install flat_remix icons
install_flat_remix() {
    echo "Installing flat-remix icons..."
    git clone https://github.com/daniruiz/flat-remix
    git clone https://github.com/daniruiz/flat-remix-gtk
    mkdir -p ~/.icons && mkdir -p ~/.themes
    cp -r flat-remix/Flat-Remix* ~/.icons/
    cp -r flat-remix-gtk/themes/* ~/.themes/
    sudo apt install -y gnome-tweaks
    check_success "Flat-remix icons installed."
}

# Install hacking tools
install_hacking_tools() {
    echo "Installing hacking tools..."
    sudo apt install -y ffuf nmap wireshark
    check_success "Hacking tools installed"

    echo "Installing BurpSuite Community..."
    sudo apt install -y snapd
    sudo snap install burpsuite
    check_success "BurpSuite Community installed"
}

# Install WebCatalog
install_webcatalog() {
    echo "Installing WebCatalog..."
    wget -O ~/webcatalog.deb "https://github.com/webcatalog/webcatalog/releases/latest/download/webcatalog.deb"
    sudo dpkg -i ~/webcatalog.deb
    sudo apt install -f -y
    check_success "WebCatalog installed"
}

# Install VirtualBox
install_virtualbox() {
    echo "Installing VirtualBox..."
    sudo apt install -y virtualbox
    check_success "VirtualBox installed"
}

# Install Telegram
install_telegram() {
    echo "Installing Telegram..."
    sudo apt install -y telegram-desktop
    check_success "Telegram installed"
}

# Clean temp files
cleanup() {
    echo "Clean temp files..."
    rm -f ~/discord.deb ~/webcatalog.deb
    rm -rf flat-remix flat-remix-gtk
    check_success "Cleanup successful."
}

# Main function to execute all installations.
main () {
    install_git
    customize_dock
    install_brave
    install_vscode
    install_discord
    install_flat_remix
    install_hacking_tools
    install_webcatalog
    install_virtualbox
    install_telegram
    cleanup
    echo "Setup completed successfully!"
}

# Execute main function
main
