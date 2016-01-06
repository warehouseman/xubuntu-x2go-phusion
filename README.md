# xubuntu-x2go-phusion

A Docker image as a Xubuntu VM with X2Go server inheriting from phusion/baseimage

I built this Xubuntu VM for trying out build systems that might bork my main machine.  I've used KVM virtual machines up 'til now, but I ain't ever going back.

The Dockerfile takes ideas from ```paimpozhil/docker-x2go-xubuntu``` but starts from ```phusion/baseimage``` instead of official ```ubuntu``` image.

Forks and pull requests : [xubuntu-x2go-phusion on GitHub](https://github.com/warehouseman/xubuntu-x2go-phusion)

## Usage:

### Arguments

    export PROJ="test07";
    export USER_PWRD="okok";
    export HOST_NUM="02";

### Build

    export IMAGE=img_${PROJ};
    docker build --rm -t "${IMAGE}" .

### Run

    export HOST_NAME=${PROJ}${HOST_NUM};
    export CONTAINER=cnt_${PROJ}${HOST_NUM};
    export IPADDR=ip_${PROJ};
    export CNT_PID=pid_${PROJ};
    
    docker run -d \
        --name ${CONTAINER} \
        --hostname=${HOST_NAME} \
        -e SSH_KEYS="$(cat ~/.ssh/id_rsa.pub)" \
        -e USER_PWRD=${USER_PWRD} \
        -e SSH_USER="$(whoami)" \
        "${IMAGE}" > "${CNT_PID}" \
      && export ${IPADDR}=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' ${CONTAINER}) \
      && eval echo -e "\\\n\\\n       \* \* \*  Address for \'${CONTAINER}\' is : \'\${${IPADDR}}\' \* \* \* \\\n" \
      && docker logs -f $(cat "${CNT_PID}");
 
