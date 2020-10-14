FROM ubuntu:20.04

WORKDIR /

RUN apt-get update \
	&& TZ=UTC DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends squid3 \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

COPY squid.conf /etc/squid/squid.conf
COPY start_squid.sh /start_squid.sh

ENTRYPOINT ["/bin/bash", "/start_squid.sh"]
