#!/bin/sh


if [ -z ${SQUID_CONF+x} ]
then
	SQUID_CONF="/etc/squid/squid.conf"
fi

echo "Starting squid in the foreground using ${SQUID_CONF}"

squid3 --foreground -f ${SQUID_CONF}
