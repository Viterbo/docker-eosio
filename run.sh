#!/bin/bash

echo "Running EOSIO v2.0.13 container..."
sleep 1
docker run -it --mount type=bind,source="$(pwd)",target=/app -p 8888:8888 eosio:v1 bash