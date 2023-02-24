FROM node:19-bullseye AS build_node_modules
RUN export DEBIAN_FRONTEND="noninteractive" && \
  apt-get update && \
  apt-get install -y git && \
  git clone https://github.com/WeeJeWel/wg-easy.git && \
  cd wg-easy/src && npm ci --production

FROM ubuntu:jammy
LABEL version="1.0.0"
ARG DEBIAN_FRONTEND="noninteractive"

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends python3-minimal && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ENV PORT=8080
COPY --from=build_node_modules /wg-easy/src /root/webapp

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    wireguard-tools iproute2 iptables nodejs && \
  echo "process.on('SIGINT',function(){process.exit(0)});" \
    >> /root/webapp/server.js && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY --chmod=777 reset-pass.sh /reset-pass.sh
COPY --chmod=777 entrypoint.sh /entrypoint.sh
EXPOSE 8080
VOLUME [ "/etc/wireguard" ]
ENTRYPOINT ["/entrypoint.sh"]