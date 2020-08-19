FROM ubuntu:18.04
ENV latest_version 1.15
ENV GOROOT /usr/local/go
ENV GOPATH $HOME/go
RUN apt update && apt -y install sqlite git gcc make wget \
    && wget https://dl.google.com/go/go$latest_version.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go$latest_version.linux-amd64.tar.gz \
    && mkdir $HOME/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin
