#!/bin/bash
aws configure set aws_access_key_id $6
aws configure set aws_secret_access_key $7
aws configure set region $8
ecs-cli configure profile --profile-name ECSProfile --access-key $6 --secret-key $7
ecs-cli configure --cluster $4 --default-launch-type FARGATE --region $8 --config-name ECSClusterConfig

echo "$(ecs-cli --version)"

services=$(aws ecs describe-services --services $1 --cluster $4 --region $8 | jq '.services')
if [ "$services" = "[]" ] && [ $5 = "Yes" ]
then
    echo "Deploying $1 with service-discovery-enabled"
    ecs-cli compose --ecs-profile ECSProfile --file $2 --ecs-params $3 --project-name $1  service up --create-log-groups --cluster-config ECSClusterConfig --enable-service-discovery
else
    echo "Deploying $1 without service discovery"
    ecs-cli compose --ecs-profile ECSProfile --file $2 --ecs-params $3 --project-name $1  service up --create-log-groups --cluster-config ECSClusterConfig
fi
