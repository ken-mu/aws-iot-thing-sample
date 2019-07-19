#!/bin/bash
set -e

POLICY_NAME="pubsub"

aws iot create-keys-and-certificate --set-as-active > cert.json

cat cert.json | jq .keyPair.PublicKey -r > thing-public-key.pem
cat cert.json | jq .keyPair.PrivateKey -r > private-key.pem

CERTIFICATED_ID=$(jq -r .certificateId cert.json)
aws iot describe-certificate --certificate-id $CERTIFICATED_ID --output text --query certificateDescription.certificatePem > cert.pem

openssl  x509 -text < cert.pem

#aws iot create-policy --policy-name ${POLICY_NAME} --policy-document file://policy.json
AWS_ACCOUNT=$(aws sts get-caller-identity | jq -r .Account)
aws iot attach-principal-policy --principal arn:aws:iot:ap-northeast-1:${AWS_ACCOUNT}:cert/$CERTIFICATED_ID --policy-name ${POLICY_NAME}
aws iot attach-thing-principal --thing-name "gw" --principal arn:aws:iot:ap-northeast-1:${AWS_ACCOUNT}:cert/$CERTIFICATED_ID

wget https://www.amazontrust.com/repository/AmazonRootCA1.pem
