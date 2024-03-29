#!/bin/bash

cat << "EOF"
______ _____ _____ _____ _   _ _        _
| ___ \  ___/  __ \  _  | \ | | |      (_)
| |_/ / |__ | /  \/ | | |  \| | |_ __ _ _ _ __   ___ _ __
|    /|  __|| |   | | | | . ` | __/ _` | | '_ \ / _ \ '__|
| |\ \| |___| \__/\ \_/ / |\  | || (_| | | | | |  __/ |
\_| \_\____/ \____/\___/\_| \_/\__\__,_|_|_| |_|\___|_|

EOF


mkdir -p /tmp/$1
cd /tmp/$1

echo "[+] Running assetfinder"
assetfinder -subs-only $1 > assetfinder-op && echo "[+] assetfinder found: `wc -l assetfinder-op | cut -d ' ' -f1` subdomains" &

echo "[+} Running subfinder"
subfinder -silent -d $1 -o subfinder-op > /dev/null 2>&1 && echo "[+] subfinder found: `wc -l subfinder-op | cut -d ' ' -f1` subdomains" &

echo "[+] Running Amass enum in passive mode"
/amass/amass enum -silent -passive -d $1 -o amass-op && echo "[+] amass found: `wc -l amass-op | cut -d ' ' -f1` subdomains" &
 
wait

echo "[+] Getting unique subdomains"
cat assetfinder-op subfinder-op amass-op | sort | uniq > all-subdomains
echo "[+] Unique subdomains found: `wc -l all-subdomains | cut -d ' ' -f1`"

echo "[+] Getting live subdomains from above list"
cat all-subdomains | httprobe -c 25 > live-subdomains
echo "[+] Live subdomains found: `wc -l live-subdomains | cut -d ' ' -f1` subdomains <------------------ Primary analysis file"

echo "[+] Running httpx on live-subdomains to get status codes and page titles."
cat live-subdomains | httpx -status-code -title -silent > live-subdomains-httpx
echo "[+] httpx output will help narrow down which subdomains to start testing on"

echo "[+] Running hakrawler on live-subdomains with depth three: -d 3"
cat live-subdomains | hakrawler > endpoint-crawl-hakrawler
echo "[+] hakrawler output will give endpoints and URLs to test with parameters as seen in code"

echo "[+] Creating zip file"
cd /tmp
zip -r $1.zip $1

echo "[+] Done. This container will now exit. Output file is at /tmp/$1.zip"
