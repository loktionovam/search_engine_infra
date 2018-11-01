FROM alpine:edge
MAINTAINER "Aleksandr Loktionov <loktionovam@gmail.com>"

ENV TERRAFORM_VERSION=0.11.8
ENV TERRAFORM_SHA256SUM=84ccfb8e13b5fce63051294f787885b76a1fedef6bdbecf51c5e586c9e20c9b7

RUN apk add --no-cache ansible=2.6.1-r0 \
                    curl=7.61.0-r0 \
                    git=2.18.0-r0 \
                    py-crypto=2.6.1-r2 \
                    py-libcloud=2.3.0-r0 \
                    py-requests=2.19.1-r0  \
                    python2=2.7.15-r1 \
                    unzip=6.0-r4 && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

ENTRYPOINT ["/bin/terraform"]
