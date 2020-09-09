### BUILD VULS AND SUPERCRONIC BINARIES
FROM golang:alpine as builder

RUN apk add --no-cache \
        git \
        make \
        gcc \
        musl-dev

RUN for repo in \
        github.com/kotakanbe/go-cve-dictionary \
        github.com/kotakanbe/goval-dictionary \
        github.com/knqyf263/gost \
        github.com/prince-chrismc/go-exploitdb \
        github.com/takuzoo3868/go-msfdb.git \
        github.com/future-architect/vuls; \
    do \
        cd $GOPATH/src/ \
     && git clone https://$repo $repo\
     && cd $repo \
     && make install; \
    done

RUN go get -d github.com/aptible/supercronic \
 && cd "${GOPATH}/src/github.com/aptible/supercronic" \
 && go mod vendor \
 && go install

### BUILD VULS IMAGE
FROM alpine:3.11

ENV LOGDIR /vuls/log/
ENV CACHEDIR /.vuls
ENV DBCACHEDIR /.cache
ENV WORKDIR /vuls
ENV CRONDIR /tmp/cron

RUN addgroup -g 1000 vuls \
 && adduser -u 1000 -G vuls -s /bin/sh -D vuls

RUN apk add --no-cache \
        openssh-client \
        ca-certificates \
        git \
 && mkdir -p $WORKDIR $LOGDIR $CACHEDIR $DBCACHEDIR $CRONDIR \
 && chown -R vuls: $WORKDIR $LOGDIR $CACHEDIR $DBCACHEDIR $CRONDIR

COPY --from=builder /go/bin/* /usr/local/bin/

VOLUME ["$WORKDIR", "$LOGDIR", "$CACHEDIR", "$DBCACHEDIR", "$CRONDIR"]
WORKDIR $WORKDIR
ENV PWD $WORKDIR

USER vuls

CMD ["supercronic", "/tmp/cron/crontab"]
