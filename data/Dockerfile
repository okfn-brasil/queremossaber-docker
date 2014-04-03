# Data
#
# Data-only container to persist data
#
# Usage:
#
#   # Build data image
#   docker build -t data -rm .
#
#   # Create a data container. (eg: queremossaber-data)
#   docker run -name queremossaber-data data
#
#   # List data from it
#   docker run -volumes-from queremossaber-data busybox ls -al /data
#
# VERSION 0.1

FROM busybox
MAINTAINER Vitor Baptista <vitor@vitorbaptista.com>

RUN mkdir /data

VOLUME ["/data"]

CMD ["true"]
