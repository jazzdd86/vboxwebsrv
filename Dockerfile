FROM alpine
MAINTAINER Christian Gatzlaff <cgatzlaff@gmail.com>

RUN apk add --no-cache bash openssh-client

ENV PORT 5678
ENV USE_KEY 0
ENV SSH_PORT 22
ENV VBOXWEBSRVPATH vboxwebsrv

# only expose default vboxwebsrv port
EXPOSE 18083

# use run.sh help to check parameters and connect to target
COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]
