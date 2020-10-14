#!/bin/bash

CONTAINER="rm-squid-proxy"
VERSION="0.7"

GIVEN_PORT=false
CONFIG_FILE=""

DOCKER_PARAMS=()
DOCKER_VOLUME="/squid_config"

# get command line args
while [[ $# -gt 0 ]]
do
	KEY="$1"

	case $KEY in
		-p|--port)
			GIVEN_PORT=true
			PARAMS+=("-p ${2}:${2}/tcp")
			shift # arg
			shift # value
		;;
		-f|--file)
			CONFIG_FILE="$2"
			shift # arg
			shift # value
		;;
		-r|--rm)
			PARAMS+=("--rm")
			shift # arg
		;;
		-h|--help)
			echo "Usage:"
			echo "${0} [-p port_number] [-f config_file] [--r]"
			echo "${0} -p 3128 -f ./squid.conf"
			echo ""
			echo "-p: port number to publish for the container"
			echo "-f: a custom config file to use in the container"
			echo "-r: remove the container when it stops"
			exit 0
		;;
		*)
			echo "Unkown option ${KEY} given"
			exit 1
		;;
	esac
done

# if no command line port was given, publish the default port
if [ ${GIVEN_PORT} = false ]
then
	PARAMS+=("-p 3128:3128/tcp")
fi

# if a config file was given mount it in the container and
# set the env var to point at it
if [ ! -z ${CONFIG_FILE} ]
then
	if [ ! -f ${CONFIG_FILE} ]
	then
		echo "Config file ${CONFIG_FILE} not found"
		exit 1
	fi

	CONFIG_BASENAME=$(basename ${CONFIG_FILE})
	CONFIG_DIR=$(dirname $(realpath ${CONFIG_FILE}))

	PARAMS+=("-e SQUID_CONF=${DOCKER_VOLUME}/${CONFIG_BASENAME}")
	PARAMS+=("-v ${CONFIG_DIR}:${DOCKER_VOLUME}")

	echo "Mounting ${CONFIG_DIR} in the container"
	echo "Warning: The container will have access to the entire directory"
fi

ID=$(docker run -d ${PARAMS[@]} ${CONTAINER}:${VERSION})

echo "Started ${CONTAINER}:${VERSION}"
echo "Stop it with: docker stop ${ID}"

exit 0
