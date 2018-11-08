FROM rabbitmq:3.6.11-alpine
LABEL version="1.9"
RUN apk add --no-cache curl

COPY download_prometheus_plugin.sh /opt/rabbitmq/
RUN /opt/rabbitmq/download_prometheus_plugin.sh

COPY --chown=rabbitmq:rabbitmq rabbitmq.config /etc/rabbitmq/
COPY --chown=rabbitmq:rabbitmq enabled_plugins /etc/rabbitmq/
