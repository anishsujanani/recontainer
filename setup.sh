#!/bin/bash

cd /

apt update
apt -y upgrade all 
apt install -y wget
apt install -y zip
apt install -y unzip
apt install -y git
apt install -y python3-pip

wget https://go.dev/dl/go1.20.4.linux-arm64.tar.gz
tar -C /usr/local -xvf go1.20.4.linux-arm64.tar.gz

go install github.com/tomnomnom/assetfinder@latest &
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest &
go install github.com/tomnomnom/httprobe@latest &
go install github.com/hakluke/hakrawler@latest &
go install github.com/tomnomnom/waybackurls@latest &
go install github.com/tomnomnom/meg@latest &
go install github.com/projectdiscovery/httpx/cmd/httpx@latest &
go install github.com/hakluke/hakrawler@latest &
wait

wget https://github.com/owasp-amass/amass/releases/download/v3.23.2/amass_Linux_arm64.zip
unzip amass_Linux_arm64.zip && mv amass_Linux_arm64 amass
