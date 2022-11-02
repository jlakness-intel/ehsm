docker run \
      --rm \
      --name pccs \
      -it \
      --cpu-shares 512 --pids-limit 100 --memory=512m --security-opt=no-new-privileges \
      -v `pwd`/certs/private.pem:/opt/intel/pccs/ssl_key/private.pem \
      -v `pwd`/certs/file.crt:/opt/intel/pccs/ssl_key/file.crt \
      -v `pwd`/config/pccs.config:/opt/intel/pccs/config/default.json \
      --read-only --tmpfs /opt/intel/pccs/logs/ --tmpfs /tmp \
      --health-cmd='pgrep -f  "/usr/bin/node -r esm pccs_server.js" || exit 1' \
      intel/pccs
