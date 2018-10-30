FROM prom/alertmanager:v0.14.0
LABEL version="0.14.0"
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY alertmanager.secrets /alertmanager.secrets

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "/bin/alertmanager", \
        "--config.file=/etc/alertmanager/config.yml", \
        "--storage.path=/alertmanager" ]
