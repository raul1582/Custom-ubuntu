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

# notion install (Lotion)
install_notion() {
    echo "Installing Notion (Lotion)..."
    wget https://raw.githubusercontent.com/puneetsl/lotion/master/setup.sh
    chmod +x setup.sh
    sudo add-apt-repository universe
    sudo apt install -y p7zip-full p7zip-rar
    check_success "Installed notion dependencies"
    ./setup.sh native
    check_success "Notion installed"
}

# Customize dock
customize_dock() {
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
    echo "Instalando Discord..."
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

#clean
cleanup() {
    echo "Clean temp files..."
    rm setup.sh
    rm ~/discord.deb
    rm -rf flat-remix flat-remix-gtk
    check_success "Cleanup successful."
}

# Main function to execute all installations.
main () {
    install_git
    install_notion
    customize_dock
    install_brave
    install_vscode
    install_discord
    install_flat_remix
    cleanup
    echo "Finish `-`"
}
# Execute main function
main