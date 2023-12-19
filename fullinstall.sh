#!/bin/bash

set -e

# Function to prompt the user with a checkbox
prompt_checkbox() {
    options=("$@")
    selected=()
    for (( i=0; i<${#options[@]}; i++ )); do
        read -p "Install ${options[$i]}? (yes/no): " yn
        case $yn in
            [Yy]* ) selected+=("${options[$i]}");;
            * ) ;;
        esac
    done
    echo "${selected[@]}"
}

# Function to prompt the user to create a new user
create_new_user() {
    read -p "Do you want to create an additional user with sudo privileges? (yes/no): " create_user
    case $create_user in
        [Yy]* )
            read -p "Enter the username for the new user: " new_username
            read -s -p "Enter the password for the new user: " new_password
            echo
            useradd -m -s /bin/bash "$new_username"
            echo "$new_username:$new_password" | chpasswd
            usermod -aG sudo "$new_username"
            printf '\nNew user created and added to sudoers group\n\n'
            echo "You can now log in with the username $new_username instead of root";;
        * )
            echo "Skipping user creation."
            ;;
    esac
}

sleep 10

# Function for logging
log() {
    echo "$(date): $1" >> installation_log.txt
}

# Display message
echo "First, we will run updates and install curl."
log "Running updates and installing curl."

# Update package repository
apt update
apt install curl -y
printf '\nCurl installed successfully\n\n'
log "Updates completed. Curl installed."

# Define options
install_options=("sudo" "docker" "docker-compose" "portainer")

# Prompt user with checkboxes
selected_options=($(prompt_checkbox "${install_options[@]}"))

# Install selected options
for option in "${selected_options[@]}"; do
    case $option in
        "sudo" )
            apt install sudo -y
            printf '\nSudo installed successfully\n\n'
            log "Sudo installed."
            create_new_user;;  # Prompt to create a new user after installing sudo
        "docker" )
            curl -fsSL https://get.docker.com -o get-docker.sh
            sh get-docker.sh
            printf '\nDocker installed successfully\n\n'
            log "Docker installed.";;
        "docker-compose" )
            COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
            sudo curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            sudo curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
            printf '\nDocker Compose installed successfully\n\n'
            log "Docker Compose installed.";;
        "portainer" )
            docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
            printf '\nPortainer installed successfully\n\n'
            log "Portainer installed.";;
    esac
done

# Final message
echo "Installation completed successfully. Check installation_log.txt for details."
log "Installation completed successfully."
