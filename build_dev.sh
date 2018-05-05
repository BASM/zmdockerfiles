#!/bin/sh

set -ex

docker build -t zoneminder/zoneminder -f development/ubuntu/xenial/Dockerfile .
