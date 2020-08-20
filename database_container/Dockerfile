### GO CVE DICT BUILD
FROM golang:alpine as go-cve-dictionary-builder

RUN apk add --no-cache \
        git \
        make \
        gcc \
        musl-dev

ENV REPOSITORY github.com/kotakanbe/go-cve-dictionary
COPY go-cve-dictionary $GOPATH/src/$REPOSITORY
RUN cd $GOPATH/src/$REPOSITORY && make install

### GOVAL DICT BUILD
FROM golang:alpine as goval-dictionary-builder

RUN apk add --no-cache \
        git \
        make \
        gcc \
        musl-dev

ENV REPOSITORY github.com/kotakanbe/goval-dictionary
COPY goval-dictionary $GOPATH/src/$REPOSITORY
RUN cd $GOPATH/src/$REPOSITORY && make install

### GOST BUILD
FROM golang:alpine as gost-builder

RUN apk add --no-cache \
        git \
        make \
        gcc \
        musl-dev

ENV REPOSITORY github.com/knqyf263/gost
COPY gost $GOPATH/src/$REPOSITORY
RUN cd $GOPATH/src/$REPOSITORY && make install

### GO EXPLOITDB BUILD
FROM golang:alpine as go-exploitdb-builder

RUN apk add --no-cache make git gcc musl-dev

ENV REPOSITORY github.com/prince-chrismc/go-exploitdb
COPY go-exploitdb $GOPATH/src/$REPOSITORY
RUN cd $GOPATH/src/$REPOSITORY && make install

### GO MSFDB BUILD
FROM golang:alpine as go-msfdb-builder

RUN apk add --no-cache make git gcc musl-dev

ENV REPOSITORY github.com/takuzoo3868/go-msfdb.git
COPY go-msfdb $GOPATH/src/$REPOSITORY
RUN cd $GOPATH/src/$REPOSITORY && make install

### FULL IMAGE BUILD
FROM alpine:3.11

ENV LOGDIR /var/log/vuls
ENV WORKDIR /vuls

RUN apk add --no-cache ca-certificates \
    && mkdir -p $WORKDIR $LOGDIR

COPY --from=go-cve-dictionary-builder /go/bin/go-cve-dictionary /usr/local/bin/
COPY --from=goval-dictionary-builder /go/bin/goval-dictionary /usr/local/bin/
COPY --from=gost-builder /go/bin/gost /usr/local/bin/
COPY --from=go-exploitdb-builder /go/bin/go-exploitdb /usr/local/bin/
COPY --from=go-msfdb-builder /go/bin/go-msfdb /usr/local/bin/

VOLUME ["$WORKDIR", "$LOGDIR"]
WORKDIR $WORKDIR
ENV PWD $WORKDIR

COPY ./scripts/ /vuls/
COPY ./crontab /var/spool/cron/crontabs/
RUN cat /var/spool/cron/crontabs/crontab >> /var/spool/cron/crontabs/root
RUN mkdir -p /var/log/cron \
    && touch /var/log/cron/cron.log

ENTRYPOINT ["sh", "./entrypoint.sh"]
