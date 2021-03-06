FROM ubuntu:latest
ENV PATH="${PATH}:/usr/local/go/bin"
ENV PATH="${PATH}:/root/go/bin"
ENV GOPATH="/root/go"
ENV GO111MODULE="on"

RUN apt update && \
	apt -y upgrade &&\
	apt install -y wget && \
	apt install -y zip && \
	apt install -y unzip && \
	apt install -y git && \
	apt install -y python3-pip && \
	wget https://golang.org/dl/go1.15.3.linux-amd64.tar.gz && \
	tar -C /usr/local  -xzf go1.15.3.linux-amd64.tar.gz && \
	go get -u github.com/tomnomnom/assetfinder && \
	go get -u -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder && \
	go get -u github.com/tomnomnom/httprobe && \
	go get github.com/hakluke/hakrawler && \
	go get github.com/tomnomnom/waybackurls && \
	go get -u github.com/tomnomnom/meg && \
	git clone https://github.com/aboul3la/Sublist3r.git && \
	go get -v github.com/projectdiscovery/httpx/cmd/httpx && \
	go get github.com/hakluke/hakrawler && \
	pip3 install -r Sublist3r/requirements.txt && \
	wget https://github.com/OWASP/Amass/releases/download/v3.14.3/amass_linux_amd64.zip && \
	unzip amass_linux_amd64.zip

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
