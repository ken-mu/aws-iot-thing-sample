#!/bin/bash
set -e

POLICY_NAME="pubsub"

CERTIFICATED_ID=$(jq -r .certificateId cert.json)
AWS_ACCOUNT=$(aws sts get-caller-identity | jq -r .Account)
aws iot detach-thing-principal --thing-name "gw" --principal arn:aws:iot:ap-northeast-1:${AWS_ACCOUNT}:cert/$CERTIFICATED_ID
aws iot detach-principal-policy --principal arn:aws:iot:ap-northeast-1:${AWS_ACCOUNT}:cert/$CERTIFICATED_ID --policy-name ${POLICY_NAME}
