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
            while true; do
                read -s -p "Enter the password for the new user: " new_password
                echo
                read -s -p "Confirm password: " confirm_password
                echo
                if [ "$new_password" != "$confirm_password" ]; then
                    echo "Passwords do not match. Please try again."
                else
                    break
                fi
            done
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
install_options=("sudo" "docker" "docker-compose" "dockge")

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
        "dockge" )
            usermod -aG docker "$new_username"
            printf '\nNew sudo user added to the docker group\n\n'
            mkdir -p /opt/stacks /opt/dockge
            cd /opt/dockge
            curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml
            docker compose up -d
            printf '\nDockge installed successfully\n\n'
            log "Dockge installed.";;
    esac
done

# Final message
echo "Installation completed successfully. Check installation_log.txt for details."
echo ""
echo "Network IP Information:"
ip a
echo ""
echo "Non-sudo user PUID and PGID: "
id $new_username
log "Installation completed successfully."
