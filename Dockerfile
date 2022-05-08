# Base image
FROM alpine:latest

# installes required packages for our script
RUN	apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  jq

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl

COPY . .
RUN ./entrypoint.sh

ENV KUBECONFIG=kube-config




# # change permission to execute the script and
# RUN chmod +x /entrypoint.sh

# # file to execute when the docker container starts up
# ENTRYPOINT ["/entrypoint.sh"]

