FROM golang:alpine as builder

RUN apk add --no-cache \
        git \
        make \
        gcc \
        musl-dev

ENV REPOSITORY github.com/kotakanbe/go-cve-dictionary
COPY go-cve-dictionary $GOPATH/src/$REPOSITORY
RUN cd $GOPATH/src/$REPOSITORY && make install


FROM alpine:3.11

ENV LOGDIR /var/log/vuls
ENV WORKDIR /vuls

RUN apk add --no-cache ca-certificates \
    && mkdir -p $WORKDIR $LOGDIR

COPY --from=builder /go/bin/go-cve-dictionary /usr/local/bin/

VOLUME ["$WORKDIR", "$LOGDIR"]
WORKDIR $WORKDIR
ENV PWD $WORKDIR

COPY ./scripts/ /vuls/
COPY ./crontab /var/spool/cron/crontabs/
RUN cat /var/spool/cron/crontabs/crontab >> /var/spool/cron/crontabs/root
RUN mkdir -p /var/log/cron \
    && touch /var/log/cron/cron.log

ENTRYPOINT ["sh", "./entrypoint.sh"]
