#!/bin/bash

# Run system updates
apt-get update
apt-get upgrade -y

# Install curl
apt-get install -y curl

# Ask if the user wants to install sudo
read -p "Do you want to install sudo? (y/n) " install_sudo
if [[ $install_sudo =~ ^[Yy]$ ]]; then
    apt-get install -y sudo
fi

# Ask if the user wants to install Docker
read -p "Do you want to install Docker? (y/n) " install_docker
if [[ $install_docker =~ ^[Yy]$ ]]; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
fi

# Ask if the user wants to install Docker Compose
read -p "Do you want to install Docker Compose? (y/n) " install_compose
if [[ $install_compose =~ ^[Yy]$ ]]; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Ask if the user wants to install Portainer
read -p "Do you want to install Portainer? (y/n) " install_portainer
if [[ $install_portainer =~ ^[Yy]$ ]]; then
    docker volume create portainer_data
    docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
fi

# Ask if the user wants to create a new sudo user
read -p "Do you want to create a new sudo user? (y/n) " create_user
if [[ $create_user =~ ^[Yy]$ ]]; then
    read -p "Enter the desired username: " username
    while true; do
        read -s -p "Enter the password: " password
        echo
        read -s -p "Confirm the password: " password_confirm
        echo
        if [[ $password == $password_confirm ]]; then
            break
        else
            echo "Passwords do not match. Please try again."
        fi
    done
    useradd -m -s /bin/bash $username
    echo "$username:$password" | sudo chpasswd
    usermod -aG sudo,docker $username
    echo "User $username has been created and added to sudo and docker groups."
fi
