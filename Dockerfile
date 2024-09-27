FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt full-upgrade -y

RUN apt update && \
    apt full-upgrade -y && \
    apt install -y git libgmp-dev gcc g++ build-essential make cmake python3 ssh rsync gzip uuid-runtime

RUN cp /usr/bin/hostname /usr/bin/hostname.real && \
    echo '#!/bin/bash\necho buildkitsandbox' > /usr/bin/hostname && \
    chmod +x /usr/bin/hostname

RUN git clone --depth 500 https://github.com/NyanCatTW1/cado-nfs && \
    cd cado-nfs && \
    git checkout 946125d6e8450967d1ca830f4e8730be09ad2f17 && \
    make -j $(nproc)

COPY sismargaret-miner /
COPY cado-client.sh /

RUN chmod +x /sismargaret-miner /cado-client.sh

COPY application.yml /

ENV DREADPOOL_IS_DOCKER=1
CMD ["/sismargaret-miner"]
