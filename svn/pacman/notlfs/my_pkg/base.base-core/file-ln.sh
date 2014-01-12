#!/bin/bash

#install -d ${1}/{bin,usr/{bin,lib}}
#ln -sv /tools/bin/{bash,cat,echo,pwd,stty} ${1}/bin
#ln -sv /tools/bin/perl ${1}/usr/bin
#ln -sv /tools/lib/libgcc_s.so{,.1} ${1}/usr/lib
#ln -sv /tools/lib/libstdc++.so{,.6} ${1}/usr/lib
#sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
#ln -sv bash ${1}/bin/sh

#ln -sv /proc/self/mounts ${1}/etc/mtab

install -dv ${1}/etc

cat > ${1}/etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:daemon:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

cat > ${1}/etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
mail:x:34:
nogroup:x:99:
EOF

install -dv ${1}/var/log
touch ${1}/var/log/{btmp,lastlog,wtmp}
chgrp -v utmp ${1}/var/log/lastlog
chmod -v 664  ${1}/var/log/lastlog
chmod -v 660  ${1}/var/log/btmp
