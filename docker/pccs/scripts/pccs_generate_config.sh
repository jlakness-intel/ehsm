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

#!/bin/bash -e

# expecting list of variable names as a parameters
function check_var_defined {
    for var in "$@"
    do
        if [ -z "${!var}" ]; then
            echo "Error! Environment variable $var not set!"
            exit 1
        fi
    done
}

# set default values to pccs admin and user passwords - not used
# in this demo but values have to be provided
export PCCS_ADMIN_PASS="${PCCS_ADMIN_PASS:=pccs_admin}"
export PCCS_USER_PASS="${PCCS_USER_PASS:=pccs_user}"
export PCCS_PORT="${PCCS_PORT:=8081}"
export PCCS_LOCAL_ONLY="${PCCS_LOCAL_ONLY:=N}"

export PCCS_ADMIN_HASH=`echo $PCCS_ADMIN_PASS | sha512sum | tr -d '[:space:]-'`
export PCCS_USER_HASH=`echo $PCCS_USER_PASS | sha512sum | tr -d '[:space:]-'`

# Variables listed below have to be defined in the container
# Throwing error if some of them are not visible
check_var_defined PCCS_API_KEY PCCS_ADMIN_PASS PCCS_USER_PASS PCCS_PORT PCCS_LOCAL_ONLY

cd ../config
envsubst < pccs.config.tpl > default.json
