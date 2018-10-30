FROM golang:1.10.4-stretch as build
ENV MONGODB_EXPORTER_REPO_URL=https://github.com/percona/mongodb_exporter.git
ENV MONGODB_EXPORTER_BUILD_DIR=src/github.com/percona/mongodb_exporter
ENV MONGODB_EXPORTER_VERSION=0.6.1

RUN apt-get update && \
    apt-get install --no-install-recommends --yes   git \
                                                    g++ \
                                                    make  && \
    rm -r /var/lib/apt/lists/* && \
    git clone "${MONGODB_EXPORTER_REPO_URL}" "${MONGODB_EXPORTER_BUILD_DIR}" && \
    cd "${MONGODB_EXPORTER_BUILD_DIR}" && \
    git checkout -b "${MONGODB_EXPORTER_VERSION}" "v${MONGODB_EXPORTER_VERSION}" && \
    make build

FROM scratch
LABEL version="0.6.1"
ENV MONGODB_EXPORTER_BUILD_DIR=src/github.com/percona/mongodb_exporter

COPY --from=build /go/$MONGODB_EXPORTER_BUILD_DIR/mongodb_exporter /
EXPOSE 9216

CMD ["/mongodb_exporter"]
