#!/system/bin/sh
echo "get iw7019 dump save "$1
if [ -f $1 ];then
 rm $1
fi
touch $1
chmod 666 $1
chgrp root $1
cat /sys/class/iw7019/dump > $1
