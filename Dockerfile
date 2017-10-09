FROM ubuntu:16.04

# Install CURL and WGET
RUN apt-get update && \
    apt-get -y install curl wget && \
    rm -rf /var/lib/apt/lists/*;

# Get Vapor repo including Swift
RUN /bin/bash -c "$(wget -qO- https://apt.vapor.sh)"

# Installing Swift & Vapor
RUN apt-get update && \
    apt-get -y install swift vapor && \
    rm -rf /var/lib/apt/lists/*;

WORKDIR /vapor

# RUN ["vapor", "build"]
# RUN ["swift", "run"]

# RUN cd /vapor && swift run
