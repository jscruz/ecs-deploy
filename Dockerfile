FROM python:alpine

ARG CLI_VERSION=1.16.134

RUN apk -uv add --no-cache groff jq less curl && \
    pip install --no-cache-dir awscli==$CLI_VERSION
RUN curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest
RUN chmod +x /usr/local/bin/ecs-cli

COPY deployment-template.sh /opt/deployment-template
RUN chmod +x /opt/deployment-template

ENTRYPOINT ["sh", "/opt/deployment-template"]
