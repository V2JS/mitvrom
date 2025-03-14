#!/system/bin/sh
if ! applypatch -c MTD:recovery:13305856:e98e4be34f224f454f73f8d736ac9a4bdf168d62; then
  applypatch -b /system/etc/recovery-resource.dat MTD:boot:9494528:39805f0ebf2b2ee95bea4dc4c9a13ff4b30aed56 MTD:recovery e98e4be34f224f454f73f8d736ac9a4bdf168d62 13305856 39805f0ebf2b2ee95bea4dc4c9a13ff4b30aed56:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
