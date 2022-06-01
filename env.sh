#! /bin/bash

export $(grep -v '^#' .env | xargs)

echo "You are using host from .env", "$host"
