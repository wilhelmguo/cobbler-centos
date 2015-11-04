#!/bin/bash

#install cobbler and config it auto
cp -fr ./config /etc/selinux/config
systemctl stop firewalld
systemctl disable firewalld 
rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum install cobbler cobbler-web dnsmasq syslinux pykickstart dhcp fence-agents
rpm -Uvh ftp://rpmfind.net/linux/epel/6/x86_64/debmirror-2.14-2.el6.noarch.rpm  --nodeps --force
systemctl enable cobblerd
systemctl start cobblerd
systemctl enable httpd
systemctl start httpd
cobbler get-loaders
cp -fr ./settings /etc/cobbler/settings
cp -fr ./modules.conf /etc/cobbler/modules.conf
systemctl enable xinetd
systemctl start xinetd
cp -fr ./rsync /etc/xinetd.d/rsync
cp -fr ./debmirror.conf etc/debmirror.conf
if [ ! $SERVER_IP ]
then
        echo "Please use $SERVER_IP set the IP address of the need to monitor."
elif [ ! $DHCP_RANGE ]
then
        echo "Please use $DHCP_RANGE set up DHCP network segment."
elif [ ! $ROOT_PASSWORD ]
then
        echo "Please use $ROOT_PASSWORD set the root password."
elif [ ! $DHCP_SUBNET ]
then
        echo "Please use $DHCP_SUBNET set the dhcp subnet."
elif [ ! $DHCP_ROUTER ]
then
        echo "Please use $DHCP_ROUTER set the dhcp router."
elif [ ! $DHCP_DNS ]
then
        echo "Please use $DHCP_DNS set the dhcp dns."
elif [ ! $ISO_PATH ]
then
        echo "Please use $DHCP_DNS set the dhcp dns."
else
        PASSWORD=`openssl passwd -1 -salt hLGoLIZR $ROOT_PASSWORD`
        sed -i "s/^server: 127.0.0.1/server: $SERVER_IP/g" /etc/cobbler/settings
        sed -i "s/^next_server: 127.0.0.1/next_server: $SERVER_IP/g" /etc/cobbler/settings
#        sed -i 's/pxe_just_once: 0/pxe_just_once: 1/g' /etc/cobbler/settings
#        sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g' /etc/cobbler/settings
        sed -i "s#^default_password.*#default_password_crypted: \"$PASSWORD\"#g" /etc/cobbler/settings
        sed -i "s/192.168.1.0/$DHCP_SUBNET/" /etc/cobbler/dhcp.template
        sed -i "s/192.168.1.5/$DHCP_ROUTER/" /etc/cobbler/dhcp.template
        sed -i "s/192.168.1.1;/$DHCP_DNS;/" /etc/cobbler/dhcp.template
        sed -i "s/192.168.1.100 192.168.1.254/$DHCP_RANGE/" /etc/cobbler/dhcp.template
        sed -i "s/192.168.1.100 192.168.1.254/$DHCP_RANGE/" /etc/cobbler/dnsmasq.template
        systemctl restart cobblerd
#        cobbler check
        cobbler sync

        mkdir /mnt/cobbler
        mountpoint=/mnt/cobbler
        #Import isos to cobbler
        for iso in `ls /mnt/iso`; do
                mount -t iso9660 -o loop,ro /mnt/iso/$iso $mountpoint
                cobbler import --name=$iso  --path=$mountpoint
                umount $mountpoint
        done
        cobbler sync
fi