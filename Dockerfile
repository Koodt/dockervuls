### BUILD VULS AND SUPERCRONIC BINARIES
FROM golang:1.16.3-alpine3.13 as builder

RUN apk add --no-cache \
        git \
        make \
        gcc \
        musl-dev

RUN for repo in \
        github.com/kotakanbe/go-cve-dictionary \
        github.com/kotakanbe/goval-dictionary \
        github.com/knqyf263/gost \
        github.com/mozqnet/go-exploitdb \
        github.com/takuzoo3868/go-msfdb; \
    do \
        cd $GOPATH/src/ \
     && git clone https://$repo $repo\
     && cd $repo \
     && make install; \
    done

RUN  cd $GOPATH/src/ \
  && git clone --depth 1 --branch v0.15.9 https://github.com/future-architect/vuls github.com/future-architect/vuls\
  && cd github.com/future-architect/vuls \
  && make install

RUN go install github.com/aptible/supercronic@v0.1.12

### BUILD VULS IMAGE
FROM alpine:3.13

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

WORKDIR $WORKDIR
ENV PWD $WORKDIR

USER vuls

CMD ["supercronic", "/tmp/cron/crontab"]
