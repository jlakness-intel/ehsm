FROM cruizba/ubuntu-dind

WORKDIR /opt/intel
SHELL ["/bin/bash", "-c"]
# install pre-requisites DEBIAN_FRONTEND=noninteractive 
RUN apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y &&\
    DEBIAN_FRONTEND=noninteractive TZ=US/Pacific apt-get -y install tzdata &&\
    DEBIAN_FRONTEND=noninteractive apt install -y vim autoconf automake build-essential cmake curl debhelper git libcurl4-openssl-dev libprotobuf-dev libssl-dev libtool lsb-release ocaml ocamlbuild protobuf-compiler wget libcurl4 libssl1.1 make g++ fakeroot libelf-dev libncurses-dev flex bison libfdt-dev libncursesw5-dev pkg-config libgtk-3-dev libspice-server-dev libssh-dev python3 python3-pip  reprepro unzip libjsoncpp-dev uuid-dev
# install SGX
RUN wget https://download.01.org/intel-sgx/sgx-linux/2.16/as.ld.objdump.r4.tar.gz && \
    tar -zxf as.ld.objdump.r4.tar.gz && \
    cp external/toolset/ubuntu20.04/* /usr/local/bin && \
    wget https://download.01.org/intel-sgx/sgx-dcap/1.13/linux/distro/ubuntu20.04-server/sgx_linux_x64_sdk_2.16.100.4.bin && \
    chmod a+x ./sgx_linux_x64_sdk_2.16.100.4.bin && \
    printf "yes\n" | ./sgx_linux_x64_sdk_2.16.100.4.bin &&\
    source /opt/intel/sgxsdk/environment &&\
    echo "source /opt/intel/sgxsdk/environment" >> ~/.bashrc
## install DCAP
RUN wget https://download.01.org/intel-sgx/sgx-dcap/1.13/linux/distro/ubuntu20.04-server/sgx_debian_local_repo.tgz &&\
    tar xzf sgx_debian_local_repo.tgz &&\
    echo 'deb [trusted=yes arch=amd64] file:///opt/intel/sgx_debian_local_repo focal main' | tee /etc/apt/sources.list.d/intel-sgx.list &&\
    wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add -
RUN apt update && DEBIAN_FRONTEND=noninteractive apt-get install -y libsgx-enclave-common-dev  libsgx-ae-qe3 libsgx-ae-qve libsgx-urts libsgx-dcap-ql libsgx-dcap-default-qpl libsgx-dcap-quote-verify-dev libsgx-dcap-ql-dev libsgx-dcap-default-qpl-dev libsgx-quote-ex-dev libsgx-uae-service libsgx-ra-network libsgx-ra-uefi
# install docker-compose
    #RUN curl -x $http_proxy -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&\
    #    chmod +x /usr/local/bin/docker-compose &&\
    #    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose &&\
    #    docker-compose --version
# build EHSM
# RUN git clone --recursive https://github.com/jlakness-intel/ehsm.git ehsm
# run EHSM
# ENTRYPOINT ["bash" "-c" "docker-compose -f /opt/intel/ehsm/dockerdocker-compose.yml logs -f"]




