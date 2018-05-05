#!/bin/sh

set -ex

docker build -t zoneminder/zoneminder -f release/el7/Dockerfile .
