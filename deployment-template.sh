#!/bin/bash
aws configure set aws_access_key_id $ECS_ACCESS_KEY
aws configure set aws_secret_access_key $ECS_SECRET_KEY
aws configure set region $ECS_REGION
ecs-cli configure profile --profile-name ECSProfile --access-key $ECS_ACCESS_KEY --secret-key $ECS_SECRET_KEY
ecs-cli configure --cluster $4 --default-launch-type FARGATE --region $ECS_REGION --config-name ECSClusterConfig

services=$(aws ecs describe-services --services $1 --cluster $4 --region $ECS_REGION | jq '.services')
if [ "$services" = "[]" ] && [ $5 = "Yes" ]
then
    echo "Deploying $1 with service-discovery-enabled"
    ecs-cli compose --ecs-profile ECSProfile --file $2 --ecs-params $3 --project-name $1  service up --create-log-groups --cluster-config ECSClusterConfig --enable-service-discovery
else
    echo "Deploying $1 without service discovery"
    ecs-cli compose --ecs-profile ECSProfile --file $2 --ecs-params $3 --project-name $1  service up --create-log-groups --cluster-config ECSClusterConfig
fi
