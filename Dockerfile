FROM ubuntu:latest
ENV PATH="${PATH}:/usr/local/go/bin"
ENV PATH="${PATH}:/root/go/bin"
ENV GOPATH="/root/go"
ENV GO111MODULE="on"
ENV DEBIAN_FRONTEND=noninteractive

COPY setup.sh /setup.sh
RUN chmod +x /setup.sh
RUN /setup.sh

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
