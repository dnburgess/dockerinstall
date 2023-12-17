DB Tech's Docker and Docker Compose Install
===

## Install Using Root (Non-Root method below)

To install the newest versions of sudo (optional depending on which script you use), curl, Docker, and docker compose, simply ssh into your server, then clone this repository with: 

```
git clone https://github.com/dnburgess/dockerinstall.git
```
If you don't have git installed, you can run:
```
apt install git
```

Change into the new directory:
```
cd dockerinstall
```

Make the file executable:
```
chmod +x dockerinstall.sh
```

Execute the file:
```
./dockerinstall.sh
```

## Install Without Using Root

If you don't want to use root/sudo, you can do the following:

Clone the repository:
```
git clone https://github.com/dnburgess/dockerinstall.git
```
If you don't have git installed, you can run:
```
apt install git
```
Change into the new directory:
```
cd dockerinstall
```

Make the file executable:
```
chmod +x dockerinstallnoroot.sh
```

Execute the file:
```
./dockerinstallnoroot.sh
```

## Install Using Root (includes Portainer) 

To install the newest versions of sudo (optional depending on which script you use), curl, Docker, and docker compose, simply ssh into your server, then clone this repository with: 

```
git clone https://github.com/dnburgess/dockerinstall.git
```
If you don't have git installed, you can run:
```
apt install git
```

Change into the new directory:
```
cd dockerinstall
```

Make the file executable:
```
chmod +x dockerportainerinstall.sh
```

Execute the file:
```
./dockerportainerinstall.sh
```

The Bash Script Explained
===

This shell script appears to automate the installation of Docker and Docker Compose on a Linux system. Here's a breakdown of what each section of the script does:
1. Set Script Options:

```
set -o errexit
set -o nounset
IFS=$(printf '\n\t')
```
- ```set -o errexit```: The script will exit if any command exits with a non-zero status.
- ```set -o nounset```: The script will exit if it tries to use an uninitialized variable.
- ```IFS=$(printf '\n\t')```: Internal Field Separator is set to newline and tab.

2. Install Docker
```
apt install sudo -y && apt install curl -y
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
printf '\nDocker installed successfully\n\n'
```

- Installs sudo and curl using the apt package manager.
- Downloads the Docker installation script using curl.
- Executes the Docker installation script using sudo sh.
- Prints a success message.

3. Wait for Docker to Start
```
printf 'Waiting for Docker to start...\n\n'
sleep 5
```
- Prints a message indicating that the script is waiting for Docker to start.
- Sleeps for 5 seconds.

4. Install Docker Compose:
```
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sudo curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
printf '\nDocker Compose installed successfully\n\n'
sudo docker-compose -v
```

- Retrieves the latest Docker Compose version from GitHub API.
- Downloads Docker Compose binary using ```curl``` and installs it in ```/usr/local/bin/```.
- Sets executable permissions for Docker Compose.
- Downloads Bash completion script for Docker Compose.
- Prints a success message.
- Displays the installed Docker Compose version.


Please note that this script assumes a Debian-based Linux distribution. If you are using a different distribution, adjustments may be needed. Additionally, it's essential to review and understand scripts before executing them, especially when using sudo commands from the internet.
