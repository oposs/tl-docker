#!/bin/sh
set -e
echo "### BUILDING TL DOCKER"
docker build --tag tl-ubuntu:latest .
