#!/system/bin/sh
echo $((500*1024*1024))  > /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon /dev/block/zram0
echo 120 > /proc/sys/vm/swappiness
echo 0   > /proc/sys/vm/page-cluster
