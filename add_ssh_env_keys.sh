#!/bin/bash

set -e

# load environment variables
source /etc/container_environment.sh

if [ -z "${SSH_KEYS}" ]; then
  # no keys found
  exit 0
fi

if [ ! -z "${SSH_USER}" ] ; then
  set +e
  egrep "^${SSH_USER}" /etc/passwd >/dev/null
  if [ $? -ne 0 ]; then
    sudo adduser ${SSH_USER} --gecos "" --disabled-password
    echo "${SSH_USER}  ALL=(ALL:ALL) ALL" | sudo tee --append /etc/sudoers
    echo "${SSH_USER}:${USER_PWRD}" | sudo chpasswd;
    EVAR="LANG"; EVARVAL="$(cat /etc/container_environment/${EVAR})";
    echo "export ${EVAR}=${EVARVAL};" >> /home/${SSH_USER}/.profile
    EVAR="LANGUAGE"; EVARVAL="$(cat /etc/container_environment/${EVAR})";
    echo "export ${EVAR}=${EVARVAL};" >> /home/${SSH_USER}/.profile
    EVAR="LC_CTYPE"; EVARVAL="$(cat /etc/container_environment/${EVAR})";
    echo "export ${EVAR}=${EVARVAL};" >> /home/${SSH_USER}/.profile
  fi
  set -e

  USR_DIR="/home/${SSH_USER}"
  SSH_DIR="${USR_DIR}/.ssh"
  mkdir -p "${SSH_DIR}";
  chown -R ${SSH_USER}:${SSH_USER} ${USR_DIR}
else
  # keys must be for root
  SSH_USER="root"
  SSH_DIR="/root/.ssh"
fi

# create empty authorized_keys file
echo "" > ${SSH_DIR}/authorized_keys

# append the keys
echo "${SSH_KEYS}" | while read KEY ; do 
  KEY_FILE="$(tempfile)"
  echo "${KEY}" >> "${KEY_FILE}"
  ssh-keygen -lf "${KEY_FILE}"
  rm "${KEY_FILE}"
  echo "${KEY}" >> "${SSH_DIR}/authorized_keys"
done

# establish ownership
chown ${SSH_USER}:${SSH_USER} "${SSH_DIR}/authorized_keys"
chmod 0600 "${SSH_DIR}/authorized_keys"

# done
exit 0

