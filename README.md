# xubuntu-x2go-phusion

A Docker image as a Xubuntu VM with X2Go server inheriting from phusion/baseimage

I built this Xubuntu VM for trying out build systems that might hose my main machine.  I've used KVM virtual machines up 'til now, but I ain't ever going back.

The Dockerfile takes ideas from ```paimpozhil/docker-x2go-xubuntu``` but starts from ```phusion/baseimage``` instead of official ```ubuntu``` image.

Forks and pull requests : [xubuntu-x2go-phusion on GitHub](https://github.com/warehouseman/xubuntu-x2go-phusion)

A "getting started" video :  [Meteor / CircleCI Tutorial -- #0 Create a Docker Machine](https://www.youtube.com/watch?v=UzA3ddE0XPA)

## Usage:

### Initial State

    yourself@yourpc:~$
    yourself@yourpc:~$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    yourself@yourpc:~$

### Image installation

#### If you want to build from GitHub

    yourself@yourpc:~$ 
    yourself@yourpc:~$ 
    yourself@yourpc:~$ git clone git@github.com:warehouseman/xubuntu-x2go-phusion.git
    Cloning into 'xubuntu-x2go-phusion'...
    remote: Counting objects: 33, done.
    remote: Compressing objects: 100% (28/28), done.
    remote: Total 33 (delta 16), reused 18 (delta 4), pack-reused 0
    Receiving objects: 100% (33/33), 6.65 KiB | 0 bytes/s, done.
    Resolving deltas: 100% (16/16), done.
    Checking connectivity... done.
    yourself@yourpc:~$ 
    
    yourself@yourpc:~$ 
    yourself@yourpc:~$ cd xubuntu-x2go-phusion
    yourself@yourpc:~/xubuntu-x2go-phusion$ 
    yourself@yourpc:~/xubuntu-x2go-phusion$ export PROJ="your_01";
    yourself@yourpc:~/xubuntu-x2go-phusion$ export IMAGE=${PROJ}_img;
    yourself@yourpc:~/xubuntu-x2go-phusion$ echo ${IMAGE}
    your_01_img
    yourself@yourpc:~$ 
    
    yourself@yourpc:~$ 
    yourself@yourpc:~/xubuntu-x2go-phusion$ docker build --rm -t "${IMAGE}" .
    Sending build context to Docker daemon 62.46 kB
    Step 1 : FROM phusion/baseimage:0.9.18
    0.9.18: Pulling from phusion/baseimage
    de9c48daf08c: Pull complete 
    10de806794b2: Pull complete 
    031fd5268e85: Pull complete
            :         :
            :         :
            
    yourself@yourpc:~$ # ( ¡ * curtailed * ! )
    
There is a [sample build log in the Wiki](https://github.com/warehouseman/xubuntu-x2go-phusion/wiki/Sample-Build).

    yourself@yourpc:~$
    yourself@yourpc:~/xubuntu-x2go-phusion$ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    your_01_img         latest              ceb9de062873        19 minutes ago      2.206 GB
    phusion/baseimage   0.9.18              6f1148d65de8        4 weeks ago         305.2 MB
    yourself@yourpc:~/xubuntu-x2go-phusion$ 
    yourself@yourpc:~/xubuntu-x2go-phusion$ cd ..
    yourself@yourpc:~$ 

#### If you want to pull from Docker Hub

    yourself@yourpc:~$ 
    yourself@yourpc:~$ export IMAGE="warehouseman/xubuntu-x2go-phusion";
    yourself@yourpc:~$ docker pull ${IMAGE};
    Using default tag: latest
    latest: Pulling from warehouseman/xubuntu-x2go-phusion
    de9c48daf08c: Pull complete 
    10de806794b2: Pull complete 
    031fd5268e85: Pull complete 
    0dc9ec408dd9: Pull complete 
    a891530d7330: Pull complete 
    151b6cd6fe5c: Pull complete 
    ea26b9670a7c: Pull complete 
    6f1148d65de8: Pull complete 
    5fa95f45c424: Pull complete 
    ed8ccee8c5a7: Pull complete 
    3e9daf830e2c: Pull complete 
    3fdbe889f9f1: Pull complete 
    30a8b62d3c74: Pull complete 
    4c7539bc5158: Pull complete 
    5991d8123e2a: Pull complete 
    6c2724addfff: Pull complete 
    3b49cb8a5595: Pull complete 
    62315c6f5051: Pull complete 
    3ea46660fb4d: Pull complete 
    13e2cdc79af1: Pull complete 
    7f05a7640ee4: Pull complete 
    673ed1075efa: Pull complete 
    329d09710a98: Pull complete 
    79617dcd1333: Pull complete 
    a149f79b7286: Pull complete 
    Digest: sha256:b37fe809c406e7ba054c375f1e6cc20c8119341296512399df628d3f0c4973eb
    Status: Downloaded newer image for warehouseman/xubuntu-x2go-phusion:latest
    yourself@yourpc:~$ 
    yourself@yourpc:~$ 
    yourself@yourpc:~$ docker images
    REPOSITORY                          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    warehouseman/xubuntu-x2go-phusion   latest              a149f79b7286        3 hours ago         2.166 GB
    yourself@yourpc:~$ 
    yourself@yourpc:~$ 

### Container Instantiation

#### Runtime arguments

    yourself@yourpc:~$ 
    yourself@yourpc:~$ export PROJ="your_01";
    yourself@yourpc:~$ export USER_PWRD="okok";
    yourself@yourpc:~$ export HOST_NUM="02";
    yourself@yourpc:~$ 

    yourself@yourpc:~$ 
    yourself@yourpc:~$ export HOST_NAME=${PROJ}${HOST_NUM};
    yourself@yourpc:~$ export CONTAINER=cnt_${PROJ}${HOST_NUM};
    yourself@yourpc:~$ export IPADDR=ip_${PROJ};
    yourself@yourpc:~$ export CNT_PID=pid_${PROJ};
    yourself@yourpc:~$ 

### Run

    yourself@yourpc:~$ docker run -d \
    >    --name ${CONTAINER} \
    >    --hostname=${HOST_NAME} \
    >    -e SSH_KEYS="$(cat ~/.ssh/id_rsa.pub)" \
    >    -e USER_PWRD=${USER_PWRD} \
    >    -e SSH_USER="$(whoami)" \
    >    "${IMAGE}" > "${CNT_PID}";
    yourself@yourpc:~$

    yourself@yourpc:~$
    yourself@yourpc:~$ eval "export ${IPADDR}=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' ${CONTAINER})";
    yourself@yourpc:~$ 
    yourself@yourpc:~$ eval echo -e "\\\n  \* \* \*  Address for \'${CONTAINER}\' is : \'\${${IPADDR}}\' \* \* \* \\\n";

     * * * Address for 'cnt_your_0102' is : '172.17.0.2' * * * 

    yourself@yourpc:~$ 
    yourself@yourpc:~$ echo ${ip_your_01};
    172.17.0.2
    yourself@yourpc:~$ 
    yourself@yourpc:~$ docker logs -f $(cat "${CNT_PID}");
    *** Running /etc/my_init.d/00_regen_ssh_host_keys.sh...
    *** Running /etc/my_init.d/add_ssh_env_keys.sh...
    Adding user `yourself' ...
    Adding new group `yourself' (1000) ...
    Adding new user `yourself' (1000) with group `yourself' ...
    Creating home directory `/home/yourself' ...
    Copying files from `/etc/skel' ...
    yourself  ALL=(ALL:ALL) ALL
    4096 3c:28:58:04:73:0c:58:d8:87:9b:5e:5b:9e:8a:c8:46  yourself.yourorg@gmail.com (RSA)
    *** Running /etc/rc.local...
    *** Booting runit daemon...
    *** Runit started as PID 51
    Jan  7 01:24:33 your_0102 syslog-ng[56]: syslog-ng starting up; version='3.5.3'
    ^C

    yourself@yourpc:~$ 
    yourself@yourpc:~$ # Preempt collision with previous key
    yourself@yourpc:~$ ssh-keygen -f "/home/yourself/.ssh/known_hosts" -R 172.17.0.2;
    # Host 172.17.0.2 found: line 77 type ECDSA
    /home/yourself/.ssh/known_hosts updated.
    Original contents retained as /home/yourself/.ssh/known_hosts.old
    yourself@yourpc:~$

    yourself@yourpc:~$ 
    yourself@yourpc:~$ ssh ${ip_your_01};
    The authenticity of host '172.17.0.2 (172.17.0.2)' can't be established.
    ECDSA key fingerprint is 96:fa:97:73:96:39:9a:18:f0:f8:68:d2:a0:4d:e4:58.
    Are you sure you want to continue connecting (yes/no)? yes

    Warning: Permanently added '172.17.0.2' (ECDSA) to the list of known hosts.
    Last login: Thu Jan  7 01:24:55 2016 from 172.17.0.1
    yourself@your_0102:~$ 

    yourself@your_0102:~$ 
    yourself@your_0102:~$ hostname
    your_0102
    yourself@your_0102:~$ sudo apt-get update
    [sudo] password for yourself: 
    Ign http://ppa.launchpad.net trusty InRelease
    Ign http://archive.ubuntu.com trusty InRelease
    Get:1 http://ppa.launchpad.net trusty Release.gpg [316 B]
    Get:2 http://archive.ubuntu.com trusty-updates InRelease [64.4 kB]
    Get:3 http://ppa.launchpad.net trusty Release [15.1 kB]
                 :                   :
                 :                   :
                 :                   :
    Get:26 http://archive.ubuntu.com trusty/restricted amd64 Packages [16.0 kB]
    Get:27 http://archive.ubuntu.com trusty/universe amd64 Packages [7,589 kB] 
    Fetched 21.5 MB in 23s (899 kB/s)
    Reading package lists... Done
    yourself@your_0102:~$ 


#### Stop the Container
 
    yourself@yourpc:~$ 
    yourself@yourpc:~$ docker stop ${CONTAINER};
    cnt_your_0102
    yourself@yourpc:~$ 

 
#### Delete the Container
 
    yourself@yourpc:~$ 
    yourself@yourpc:~$ docker rm ${CONTAINER};
    cnt_your_0102
    yourself@yourpc:~$ 

#### Delete the Image
 
    yourself@yourpc:~$ 
    yourself@yourpc:~$ 
    yourself@yourpc:~$ docker rmi ${IMAGE};
    Untagged: warehouseman/xubuntu-x2go-phusion:latest
    Deleted: a149f79b72861a40acbecb98e3fb57ae7a84fc1a421ba8aa89054792beb34463
    Deleted: 79617dcd1333f7be9173901f5730b96d197be648ed643fff61a55a7f190e6868
    Deleted: 329d09710a9889b02607549c870be3adb4fb9a592af4f6eda89397a1bca5a8c2
    Deleted: 673ed1075efa6e865ade3eac6c9278fca707e7da873ef0ab9bfe3d58495a44d9
    Deleted: 7f05a7640ee45d263c5b0d1d07d3e4eee2446e8de7e8eb68fca8320aa3fc481e
    Deleted: 13e2cdc79af13272ba41efd545a324be2cf4aadf5df5b07452480615be17089b
    Deleted: 3ea46660fb4d7c4357497199688d6310eda5e36f4766c970298327da916995d9
    Deleted: 62315c6f5051bd0fbd45b6dc5f8cf701c28460e5914765a92103871a984e003f
    Deleted: 3b49cb8a5595c24e167659e01652b5a7bfc5c1ebe7caa0cda52514335eaf015a
    Deleted: 6c2724addfffaab1ec2451d0afce1abb406503636a1f86e39935ed0514fbfd21
    Deleted: 5991d8123e2ac9be4879234b34334912aabc1173f15a63454dba8e2782b207bb
    Deleted: 4c7539bc5158daff8394dc6e23b10d7bacc2accfc1b4d57a78b1230e8bb34055
    Deleted: 30a8b62d3c74f431b6cb08a1f0ca3a22f2e114dbbc37aa8289fcbb335f2ffa57
    Deleted: 3fdbe889f9f1a7796f065fabaa4566c5e3fffe71c61e41d76e42b057e5ddce50
    Deleted: 3e9daf830e2c844546f774cf9980cad1499d6423e73bf06863888b224cb4b8fc
    Deleted: ed8ccee8c5a78217499ed9fb26430a5306a7bf30afe60e36cb117d9906040f74
    Deleted: 5fa95f45c424432dfe19a1fcaebb837f9b363d6aa1b21b72c8bf1b796321d726
    Deleted: 6f1148d65de85a68affd54390a342cf11db30f1ac7981dafa0f566788ddb2ae4
    Deleted: ea26b9670a7cd5c07397c6f2f95c3b235e9f125bae23309235bb0a888a6e1855
    Deleted: 151b6cd6fe5c9180cf6d3b2e66e56a26b810092555d184204555191e4fa16aa3
    Deleted: a891530d7330b494967b76c21627beeb3d73a5042f803f3f396c71e908eaea94
    Deleted: 0dc9ec408dd9dd2ac37b932d2422fa7d174fb50a8981580ed0524895e2660b92
    Deleted: 031fd5268e85512f8a8772113eb8e94f39cc84fcc2089439a83c4baf69e9594b
    Deleted: 10de806794b29c4743638776ffeaf9d1b5ba0e945ee34f2237481c060bbc7312
    Deleted: de9c48daf08cf5bf5f782e27605fd9cdba2f6f927fbeb7ce5817e6ef00c3c4ae
    yourself@yourpc:~$ 


###  Connecting with X2GO

![Create New Session](https://github.com/warehouseman/xubuntu-x2go-phusion/blob/master/images/x2go_newsess.png)

![New Session Button](https://github.com/warehouseman/xubuntu-x2go-phusion/blob/master/images/x2go_client.png)

![Starting Session](https://github.com/warehouseman/xubuntu-x2go-phusion/blob/master/images/x2go_starting.png)

![New Machine Starting](https://github.com/warehouseman/xubuntu-x2go-phusion/blob/master/images/x2go_xub.png)

![New Machine Starting](https://github.com/warehouseman/xubuntu-x2go-phusion/blob/master/images/x2go_xubready.png)





