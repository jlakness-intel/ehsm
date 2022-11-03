FROM couchdb:3.2

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
RUN apt update && DEBIAN_FRONTEND=noninteractive apt-get install -y libsgx-enclave-common-dev  libsgx-ae-qe3 libsgx-ae-qve libsgx-urts libsgx-dcap-ql libsgx-dcap-default-qpl libsgx-dcap-quote-verify-dev libsgx-dcap-ql-dev libsgx-dcap-default-qpl-dev libsgx-quote-ex-dev libsgx-uae-service libsgx-ra-network libsgx-ra-uefi sgx-dcap-pccs
# build EHSM
WORKDIR /home
RUN git clone --recursive https://github.com/intel/ehsm.git \
    && cd ehsm \
    && make
# install EHSM
WORKDIR /home/ehsm/ehsm_kms_service
RUN cp /home/ehsm/out/ehsm-core/libehsmnapi.so . \
    && cp /home/ehsm/out/ehsm-core/libenclave-ehsm-core.signed.so .
RUN npm install
COPY start_all.sh /home
RUN chmod 744 /home/start_all.sh

EXPOSE 9000
EXPOSE 8888

ENTRYPOINT [ "bash","-c","/home/start_all.sh" ]