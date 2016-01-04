#!/bin/bash

set -e

# load environment variables
source /etc/container_environment.sh

if [ -z "${SSH_KEYS}" ]; then
    # there are no environment keys to add, just get outta here
    exit 0
fi

if [ ! -z "${SSH_USER}" ] ; then
    set +e
    egrep "^${SSH_USER}" /etc/passwd >/dev/null
    if [ $? -ne 0 ]; then
        sudo adduser ${SSH_USER} --gecos "" --disabled-password
    fi
    set -e

    USR_DIR="/home/${SSH_USER}"
    SSH_DIR="${USR_DIR}/.ssh"
    mkdir -p "${SSH_DIR}";
    chown -R ${SSH_USER}:${SSH_USER} ${USR_DIR}
else
    # assume we're root
    SSH_USER="root"
    SSH_DIR="/root/.ssh"
fi

# create authorized_keys if not present
# truncate the file, start from scratch
echo "" > ${SSH_DIR}/authorized_keys

# add the keys
echo "${SSH_KEYS}" | while read KEY ; do 
    KEY_FILE="$(tempfile)"
    echo "${KEY}" >> "${KEY_FILE}"
    ssh-keygen -lf "${KEY_FILE}"
    rm "${KEY_FILE}"
    echo "${KEY}" >> "${SSH_DIR}/authorized_keys"
done

# chown the file
chown ${SSH_USER}:${SSH_USER} "${SSH_DIR}/authorized_keys"

# set file permissions
chmod 0600 "${SSH_DIR}/authorized_keys"

# exit clean
exit 0

