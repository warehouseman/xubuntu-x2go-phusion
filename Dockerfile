# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.18
MAINTAINER Warehouseman "mhb.warehouseman@gmail.com"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN add-apt-repository ppa:x2go/stable

RUN apt-get -y update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN echo -e "\n\n\n* * *  Running apt dist upgrade  * * * \n\n"
RUN apt-get dist-upgrade -y -o Dpkg::Options::="--force-confold"

RUN echo -e "\n\n\n* * *  Installing Xubuntu Desktop  * * * \n\n"
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xubuntu-desktop 

RUN echo -e "\n\n\n* * *  Installing X2Go Server  * * * \n\n"
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y x2goserver

RUN echo -e "\n\n\n* * *  Installing X2Go Server Session * * * \n\n"
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y x2goserver-xsession

RUN echo -e "\n\n\n* * *  Installing Convenience Tools * * * \n\n"
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nano lshw gettext gedit gnome-terminal

RUN echo -e "\n\n\n* * *  Preparing SSH Host Keys  * * * \n\n"
RUN rm -f /etc/service/sshd/down
# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN echo -e "\n\n\n* * *  Authorizing SSH client key  * * * \n\n"
ADD id_rsa.pub /tmp/id_rsa.pub
RUN cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys

RUN echo -e "\n\n\n* * *  Cleaning up  * * * \n\n"
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && apt-get -y autoremove


