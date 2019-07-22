#!/bin/bash
set -e

./create-devicecert.sh

python -u pub.py ${AWSIOT_HOST}

