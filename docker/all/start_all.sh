#!/bin/sh
cd /opt/intel/pccs && node -r esm /opt/intel/pccs/pccs_server.js &
cd /home/ehsm/out/ehsm-dkeyserver && /home/ehsm/out/ehsm-dkeyserver/ehsm-dkeyserver &
cd /home/ehsm/out/ehsm-dkeycache && ./ehsm-dkeycache -i 127.0.0.1 -p 8888 &
cd /home/ehsm/ehsm_kms_service/ && node /home/ehsm/ehsm_kms_service/ehsm_kms_server.js 
