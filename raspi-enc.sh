#mount.sh
#!/bin/bash
cryptsetup luksOpen /dev/encdisk001 encpart
mount -t ext4 /dev/mapper/encpart /emocan
iptables -A INPUT -i wlan0 -p tcp --dport 21 -j DROP
iptables -A INPUT -i wlan0 -p tcp --dport 139 -j DROP
iptables -A INPUT -i wlan0 -p tcp --dport 445 -j DROP
service vsftpd start
service smbd start

#umount.sh
#!/bin/bash
service vsftpd stop
service smbd stop
find /emocan -name $"._*" -exec rm -rf {} \;
umount /emocan
cryptsetup luksClose encpart

#/etc/vsftpd.conf
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
anon_upload_enable=NO
anon_mkdir_write_enable=NO
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
local_root=/emocan
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
utf8_filesystem=YES

#/etc/samba/smb.conf
[shared]
   comment = SharedArea
   browsable = yes
   read only = no
   create mask = 0760
   directory mask = 0760
   valid users = pi
   guest ok = no
   path = /emocan
