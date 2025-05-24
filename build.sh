#!/bin/bash

echo 'Building docker image...'
sleep 1

docker build -f Dockerfile \
    --tag eosio:v1 \
    --build-arg USER_ID=$(id -u) \
    --build-arg GROUP_ID=$(id -g) \
    .
