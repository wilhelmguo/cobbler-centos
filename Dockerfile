# Dockerfile for Cobbler 
FROM centos:centos7
MAINTAINER  Tuan800 
COPY ./config /etc/selinux/config
# RUN systemctl stop firewalld
# RUN systemctl disable firewalld  
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum -y install cobbler cobbler-web dnsmasq syslinux pykickstart fence-agents dhcp openssl
RUN apachectl ; cobblerd ; cobbler get-loaders ; pkill cobblerd ; pkill httpd
RUN rpm -Uvh ftp://rpmfind.net/linux/epel/6/x86_64/debmirror-2.14-2.el6.noarch.rpm  --nodeps --force
# RUN systemctl enable cobblerd
# RUN systemctl start cobblerd
# RUN systemctl enable httpd
# RUN systemctl start httpd
COPY ./settings /etc/cobbler/settings
# IP_ETH1=$(ifconfig eth0 | grep 'inet addr:' | cut -d":" -f2 | cut -d" " -f1)
# RUN sed -i '/next_server:127.0.0.1/c\next_server:{IP_ETH1}' /etc/cobbler/settings
# RUN sed -i '/server:127.0.0.1/c\next_server:{IP_ETH1}' /etc/cobbler/settings
COPY ./modules.conf /etc/cobbler/modules.conf
# RUN systemctl enable xinetd
# RUN systemctl start xinetd
COPY ./rsync /etc/xinetd.d/rsync
COPY ./debmirror.conf etc/debmirror.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/bin/bash", "/start.sh"]