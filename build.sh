#!/bin/sh
set -e
TLPORT=9922
export TLHOST=$1
export TLUSER=hello
export TLPASS=world
if [ x$TLHOST = x ]; then
cat <<EOF
Usage: $0 <hostname>

Create thinlink docker and start it, expecting connections to the given hostname
EOF
fi
echo "### BUILDING TL DOCKER"
docker build --tag tl-ubuntu:latest .
