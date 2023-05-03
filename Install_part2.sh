#!/bin/sh

# Part 2 of 2 for the installation of MinIO and setting it up. 
# Reason for 2 parts is that we need to reboot after creating the disks

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Variables
USER="administrator"
PASS="ThisIsALongPassword"
VOLUMES="/mnt/disk{1...12}"
HOST="localhost"

function Banner
{
    echo "    __  ___ _         ____ ____              _____              _         __       ";
    echo "   /  |/  /(_)____   /  _// __ \            / ___/ _____ _____ (_)____   / /_ _____";
    echo "  / /|_/ // // __ \  / / / / / /  ______    \__ \ / ___// ___// // __ \ / __// ___/";
    echo " / /  / // // / / /_/ / / /_/ /  /_____/   ___/ // /__ / /   / // /_/ // /_ (__  ) ";
    echo "/_/  /_//_//_/ /_//___/ \____/            /____/ \___//_/   /_// .___/ \__//____/  ";
    echo "                                                              /_/                  ";
    echo "                               Part 2 of 2                                         "
    echo "By William Mailhot"
    echo -e "\n\n"
}

function CreateCertFolder
{
    echo "Create certificate Folder [...]"
    sudo mkdir -p /home/minio/.minio/certs
    echo -e "Create certificate Folder [${GREEN}+${NC}]"
    echo -e "\n"
}

function CreateEnvFile
{
    echo "Create Environment File [...]"
    sudo touch /etc/default/minio

    echo "MINIO_ROOT_USER=$USER" | sudo tee -a /etc/default/minio
    echo "MINIO_ROOT_PASSWORD=$PASS" | sudo tee -a /etc/default/minio
    echo -e "MINIO_VOLUMES=\"$VOLUMES\"" | sudo tee -a /etc/default/minio
    echo -e "MINIO_OPTS=\"--certs-dir /home/minio/.minio/certs --console-address :9001\"" | sudo tee -a /etc/default/minio

    echo -e "Create Environment File [${GREEN}+${NC}]"
    echo -e "\n"
}

# Not needed unless you want MinIO to work with Veeam
function DownloadCertGen
{
    echo "Download CertGen and Install [...]"
    wget -q "https://github.com/minio/certgen/releases/download/v1.2.1/certgen_1.2.1_linux_amd64.deb"
    sudo dpkg -i "certgen_1.2.1_linux_amd64.deb"
    echo -e "Download CertGen and Install [${GREEN}+${NC}]"
    echo -e "\n"
}

# Not needed unless you want MinIO to work with Veeam
function GenerateCerts
{
    echo "Generate Certificates [...]"
    cd /home/minio/.minio/certs
    certgen -host $HOST
    echo -e "Generate Certificates [${GREEN}+${NC}]"
    echo -e "\n"
}

function SetPermissions
{
    echo "Set Certificate Permissions [...]"
    sudo chown -R minio-user:minio-user /home/minio/
    echo -e "Set Certificate Permissions [${GREEN}+${NC}]"
    echo -e "\n"
}

function StartServices
{
    echo "Enable MinIO Service and Start [...]"
    echo -e "${RED} IF YOU DO NOT SEE HTTPS BEFORE YOUR HOSTNAME, THE CERT GEN DIDN'T WORK OR WRONG PERMISSIONS"
    sudo systemctl enable minio
    sudo systemctl start minio
    sudo systemctl status minio
    echo -e "Enable MinIO Service and Start [${GREEN}+${NC}]"
    echo -e "\n"
}

function InstallMC
{
    echo "Install MC, this may take a while [...]"
    wget -q "https://dl.min.io/client/mc/release/linux-amd64/mc"
    chmod +x mc
    echo -e "Install MC [${GREEN}+${NC}]"
    echo -e "\n"
}

function Done
{
    echo "Done, don't forget to link mc to your minio instance and set erasure coding"
}


Banner
CreateCertFolder
CreateEnvFile
DownloadCertGen
GenerateCerts
SetPermissions
StartServices
InstallMC
Done

