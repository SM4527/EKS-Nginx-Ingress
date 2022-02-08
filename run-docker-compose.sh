#!/bin/bash

# default or other TF workspace
env=$(docker-compose run --rm terraform workspace show | tr -d '\r');

docker-compose -f docker-compose.yaml -f docker-compose.${env}.yaml run --rm $@