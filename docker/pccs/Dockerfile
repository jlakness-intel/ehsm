################################################################################
# BSD LICENSE
#
# Copyright(c) 2021 Intel Corporation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the
#     distribution.
#   * Neither the name of Intel Corporation nor the names of its
#     contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

FROM ubuntu:22.04 AS builder

# DCAP version (github repo branch, tag or commit hash)
ARG DCAP_VERSION=DCAP_1.13

# update and install packages
# hadolint ignore=DL3008
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -yq && \
    apt-get upgrade -yq && \
    apt-get install -yq --no-install-recommends \
            build-essential \
            ca-certificates \
            curl \
            git \
            cracklib-runtime \
            zip

# install node.js
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends nodejs

# cleanup apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# clone DCAP repo
RUN git clone https://github.com/intel/SGXDataCenterAttestationPrimitives.git -b ${DCAP_VERSION} && \
    rm -rf /SGXDataCenterAttestationPrimitives/.git/

# set PWD to PCKCertSelection dir
WORKDIR /SGXDataCenterAttestationPrimitives/tools/PCKCertSelection/

# build libPCKCertSelection library and copy to lib folder
RUN make && \
    mkdir -p ../../QuoteGeneration/pccs/lib && \
    cp ./out/libPCKCertSelection.so ../../QuoteGeneration/pccs/lib/ && \
    make clean

# set PWD to PCCS dir
WORKDIR /SGXDataCenterAttestationPrimitives/QuoteGeneration/pccs/

# build pccs
RUN npm config set proxy $http_proxy && \
    npm config set http-proxy $http_proxy && \
    npm config set https-proxy $https_proxy && \
    npm config set engine-strict true && \
    npm install

# build final image
FROM ubuntu:22.04

HEALTHCHECK --interval=5s --timeout=3s CMD pgrep -f  "/usr/bin/node -r esm pccs_server.js" || exit 1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -yq && \
    apt-get upgrade -yq && \
    apt-get clean && \
    rm -rf  /var/log/*log /var/lib/apt/lists/* /var/log/apt/* /var/lib/dpkg/*-old /var/cache/debconf/*-old

COPY --from=builder /usr/bin/node /usr/bin/node
COPY --from=builder /SGXDataCenterAttestationPrimitives/QuoteGeneration/pccs/ /opt/intel/pccs/

WORKDIR /opt/intel/pccs/

# entrypoint to start pccs
ENTRYPOINT ["/usr/bin/node",  "-r", "esm", "pccs_server.js"]
