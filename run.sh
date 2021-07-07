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

echo "[+] Running Sublist3r"
python3 /Sublist3r/sublist3r.py -d $1 -o sublist3r-op > /dev/null 2>&1 && echo "[+] sublist3r found: `wc -l sublist3r-op | cut -d ' ' -f1` subdomains" &

wait

echo "[+] Getting unique subdomains"
cat assetfinder-op subfinder-op sublist3r-op | sort | uniq > all-subdomains
echo "[+] Unique subdomains found: `wc -l all-subdomains | cut -d ' ' -f1`"

echo "[+] Getting live subdomains from above list"
cat all-subdomains | httprobe > live-subdomains
echo "[+] Live subdomains found: `wc -l live-subdomains | cut -d ' ' -f1` subdomains <------------------ Primary analysis file"

echo "[+] Running live subdomains through wayback"
cat live-subdomains | waybackurls > live-subdomains-wayback
echo "[+} Variants of live subdomains from wayback: `wc -l live-subdomains-wayback | cut -d ' ' -f1` <---------- Secondary analysis file"

echo "[+] Creating zip file"
cd /tmp
zip -r $1.zip $1

echo "[+] Done. This container will now exit. Output file is at /tmp/$1.zip"
echo "[+] Run the following command:"
echo "		docker cp $(hostname):/tmp/$1.zip . && docker container rm $(hostname)"
