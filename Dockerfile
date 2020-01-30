FROM python:alpine

ARG CLI_VERSION=1.16.134

RUN apk -uv add --no-cache groff jq less curl && \
    pip install --no-cache-dir awscli==$CLI_VERSION

COPY deployment-template.sh /opt/deployment-template
RUN chmod +x /opt/deployment-template

ENTRYPOINT ["sh", "/opt/deployment-template"]
