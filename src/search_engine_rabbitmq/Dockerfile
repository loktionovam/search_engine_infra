FROM rabbitmq:3.6.11-alpine
LABEL version="1.0"
COPY --chown=rabbitmq:rabbitmq rabbitmq.config /etc/rabbitmq/
COPY --chown=rabbitmq:rabbitmq definitions.json /etc/rabbitmq/
