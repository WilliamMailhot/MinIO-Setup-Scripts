#!/bin/sh

# Part 1 of 2 for the installation of MinIO and setting it up. 
# Reason for 2 parts is that we need to reboot after creating the disks

# Linux locations
wget=/usr/bin/wget
dpkg=/usr/bin/dpkg
find=/usr/bin/find

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

function Banner
{
    echo "    __  ___ _         ____ ____              _____              _         __       ";
    echo "   /  |/  /(_)____   /  _// __ \            / ___/ _____ _____ (_)____   / /_ _____";
    echo "  / /|_/ // // __ \  / / / / / /  ______    \__ \ / ___// ___// // __ \ / __// ___/";
    echo " / /  / // // / / /_/ / / /_/ /  /_____/   ___/ // /__ / /   / // /_/ // /_ (__  ) ";
    echo "/_/  /_//_//_/ /_//___/ \____/            /____/ \___//_/   /_// .___/ \__//____/  ";
    echo "                                                              /_/                  ";
    echo "                               Part 1 of 2                                         "
    echo "By William Mailhot"
    echo -e "\n\n"
}

function DownloadServer
{
    echo "Download MinIO Server Files [...]"
    wget -q -r --accept-regex=".*\.deb" "https://dl.min.io/server/minio/release/linux-amd64/"
    echo -e "Download MinIO Server Files [${GREEN}+${NC}]"
    echo -e "\n"
}

function InstallServerPkg
{
    echo "Install MinIO [...]"
    sudo dpkg -i "$(find . -name *.deb)" > /dev/null
    echo -e "Install MinIO [${GREEN}+${NC}]"
    echo -e "\n"
}

function InstallMKFS
{
    echo "Install mkfs.xfs [...]"
    sudo apt -qq install -y xfsprogs > /dev/null
    echo -e "Install mkfs.xfs [${GREEN}+${NC}]"
    echo -e "\n"
}

# Add or remove disks here
function SetupDisks
{
    echo "Setup Disks 1-12 [...]"
    sudo mkfs.xfs /dev/sdb -f -L DISK1
    sudo mkfs.xfs /dev/sdc -f -L DISK2
    sudo mkfs.xfs /dev/sdd -f -L DISK3
    sudo mkfs.xfs /dev/sde -f -L DISK4
    sudo mkfs.xfs /dev/sdf -f -L DISK5
    sudo mkfs.xfs /dev/sdg -f -L DISK6
    sudo mkfs.xfs /dev/sdh -f -L DISK7
    sudo mkfs.xfs /dev/sdi -f -L DISK8
    sudo mkfs.xfs /dev/sdj -f -L DISK9
    sudo mkfs.xfs /dev/sdk -f -L DISK10
    sudo mkfs.xfs /dev/sdl -f -L DISK11
    sudo mkfs.xfs /dev/sdm -f -L DISK12
    echo -e "Setup Disks 1-12 [${GREEN}+${NC}]"
    echo -e "\n"
}

# Add or remove disks here
function SetupFSTAB
{
    echo "Setup ftstab disk mounting [...]"
    echo "LABEL=DISK1 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK2 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK3 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK4 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK5 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK6 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK7 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK8 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK9 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK10 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK11 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo "LABEL=DISK12 /mnt/disk1 xfs defaults,noatime 0 2 " | sudo tee -a /etc/fstab
    echo -e "Setup ftstab disk mounting [${GREEN}+${NC}]"
    echo -e "\n"
}


# Add or remove disks here
function SetupUser
{
    echo "Setup user and group permissions [...]"
    sudo groupadd -r minio-user
    sudo useradd -M -r -g minio-user minio-user
    sudo chown minio-user /mnt/disk1 /mnt/disk2 /mnt/disk3 /mnt/disk4 /mnt/disk5 /mnt/disk6 /mnt/disk7 /mnt/disk8 /mnt/disk9 /mnt/disk10 /mnt/disk11 /mnt/disk12
    echo -e "Setup user and group permissions [${GREEN}+${NC}]"
    echo -e "\n"
}

Banner
DownloadServer
InstallServerPkg
InstallMKFS
SetupDisks
SetupFSTAB
SetupUser

sudo reboot

