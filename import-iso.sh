#!/bin/bash

#install cobbler and config it auto

mkdir /mnt/cobbler
mountpoint=/mnt/cobbler
#Import isos to cobbler
for iso in `ls /opt/iso`; do
mount -t iso9660 -o loop,ro /opt/iso/$iso $mountpoint
cobbler import --name=$iso  --path=$mountpoint
umount $mountpoint
done
cobbler sync

