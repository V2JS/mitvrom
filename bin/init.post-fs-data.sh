#!/system/bin/sh

function bt_fw_comp()
{
    bt_fm_src="/system/etc/bluetooth/BCM4345C0.hcd"
    bt_fm_dst="/tvinfo/BCM4345C0.hcd"
    echo "bt_fw_comp begin"
    if [ -f $bt_fm_dst ]; then
        echo "file $bt_fm_dst is exist"
        md5_src=`md5sum $bt_fm_src |busybox awk '{print $1}'`
        md5_dst=`md5sum $bt_fm_dst |busybox awk '{print $1}'`
        if [ "$md5_src" = "$md5_dst" ]; then
            echo "file $bt_fm_dst is same $bt_fm_src"
        else
            echo "file $bt_fm_dst is not same $bt_fm_src"
            cp $bt_fm_src $bt_fm_dst
        fi
    else
        echo "file $bt_fm_dst is not exist"
        cp $bt_fm_src $bt_fm_dst
    fi
}

function bt_fw_comp_qcom()
{
    bt_fm_src="/system/etc/bluetooth/rampatch_tlv_tf_1.1.tlv"
    bt_fm_dst="/tvinfo/rampatch_tlv_tf_1.1.tlv"
    bt_nvram_src="/system/etc/bluetooth/nvm_tlv_tf_1.1.bin"
    bt_nvram_dst="/tvinfo/nvm_tlv_tf_1.1.bin"
    echo "bt_fw_comp_qcom begin"
    if [ -f $bt_fm_dst ]; then
        echo "file $bt_fm_dst is exist"
        md5_src=`md5sum $bt_fm_src |busybox awk '{print $1}'`
        md5_dst=`md5sum $bt_fm_dst |busybox awk '{print $1}'`
        if [ "$md5_src" = "$md5_dst" ]; then
            echo "file $bt_fm_dst is same $bt_fm_src"
        else
            echo "file $bt_fm_dst is not same $bt_fm_src"
            cp $bt_fm_src $bt_fm_dst
        fi
    else
        echo "file $bt_fm_dst is not exist"
        cp $bt_fm_src $bt_fm_dst
    fi

    if [ -f $bt_nvram_dst ]; then
        echo "file $bt_nvram_dst is exist"
        md5_src=`md5sum $bt_nvram_src |busybox awk '{print $1}'`
        md5_dst=`md5sum $bt_nvram_dst |busybox awk '{print $1}'`
        if [ "$md5_src" = "$md5_dst" ]; then
            echo "file $bt_nvram_dst is same $bt_nvram_src"
        else
            echo "file $bt_nvram_dst is not same $bt_nvram_src"
            cp $bt_nvram_src $bt_nvram_dst
        fi
    else
        echo "file $bt_nvram_dst is not exist"
        cp $bt_nvram_src $bt_nvram_dst
    fi
}

function bt_fw_comp_rtk()
{
    bt_fm_src="/system/etc/bluetooth/rtl8723ds_fw"
    bt_fm_dst="/tvinfo/rtl8723ds_fw"
    bt_nvram_src="/system/etc/bluetooth/rtl8723ds_config"
    bt_nvram_dst="/tvinfo/rtl8723ds_config"
    bt_conf_src="/system/etc/bluetooth/rtkbt.conf"
    bt_conf_dst="/tvinfo/rtkbt.conf"
    echo "bt_fw_comp_rtk begin"
    if [ -f $bt_fm_dst ]; then
        echo "file $bt_fm_dst is exist"
        md5_src=`md5sum $bt_fm_src |busybox awk '{print $1}'`
        md5_dst=`md5sum $bt_fm_dst |busybox awk '{print $1}'`
        if [ "$md5_src" = "$md5_dst" ]; then
            echo "file $bt_fm_dst is same $bt_fm_src"
        else
            echo "file $bt_fm_dst is not same $bt_fm_src"
            cp $bt_fm_src $bt_fm_dst
        fi
    else
        echo "file $bt_fm_dst is not exist"
        cp $bt_fm_src $bt_fm_dst
    fi

    if [ -f $bt_nvram_dst ]; then
        echo "file $bt_nvram_dst is exist"
        md5_src=`md5sum $bt_nvram_src |busybox awk '{print $1}'`
        md5_dst=`md5sum $bt_nvram_dst |busybox awk '{print $1}'`
        if [ "$md5_src" = "$md5_dst" ]; then
            echo "file $bt_nvram_dst is same $bt_nvram_src"
        else
            echo "file $bt_nvram_dst is not same $bt_nvram_src"
            cp $bt_nvram_src $bt_nvram_dst
        fi
    else
        echo "file $bt_nvram_dst is not exist"
        cp $bt_nvram_src $bt_nvram_dst
    fi

        if [ -f $bt_conf_dst ]; then
        echo "file $bt_conf_dst is exist"
        md5_src=`md5sum $bt_conf_src |busybox awk '{print $1}'`
        md5_dst=`md5sum $bt_conf_dst |busybox awk '{print $1}'`
        if [ "$md5_src" = "$md5_dst" ]; then
            echo "file $bt_conf_dst is same $bt_conf_src"
        else
            echo "file $bt_conf_dst is not same $bt_conf_src"
            cp $bt_conf_src $bt_conf_dst
        fi
    else
        echo "file $bt_conf_dst is not exist"
        cp $bt_conf_src $bt_conf_dst
    fi
}

# Restore /data/system/latest-upgradeinfo.txt
restore_upgrade_info()
{
	upgrade_file=/data/system/latest-upgradeinfo.txt
	upgrade_bak=/cache/recovery/latest_upgradeinfo

	if [ -f ${upgrade_bak} ]; then
		mv -fv ${upgrade_bak} ${upgrade_file}
		chmod 0664 ${upgrade_file}
		chown system:system ${upgrade_file}
	fi
}

#bt fw compare and copy for uboot
bt_fw_comp

#bt qualcomm fw compare and copy for uboot
bt_fw_comp_qcom

#bt realteck fw compare and copy for uboot
bt_fw_comp_rtk

restore_upgrade_info

timestamp=`date "+%Y-%m-%d-%H%M%S"`
os_version=`getprop ro.build.version.incremental`
event_file=/data/log/history_event
erasedata_bak_event=/data/log/recovery/history_event
# copy kernel panic log
apanic_dir=r${os_version}_apanic_$timestamp
for dmesg_file_src in $(ls /sys/fs/pstore/dmesg-ramoops-*);do
    mkdir /data/log/${apanic_dir}
    cp $dmesg_file_src /data/log/${apanic_dir}/
    rm $dmesg_file_src
done
chmod 0775 /data/log/${apanic_dir}
chmod 0774 /data/log/${apanic_dir}/*
chown log:log -R /data/log/${apanic_dir}

# copy recovery log and restore ${event_fiel}
cp -r /cache/recovery /data/log
if [ -f ${erasedata_bak_event} ]; then
    mv -fv ${erasedata_bak_event} ${event_file}
fi

chmod 0774 /data/log/recovery
chmod 0664 /data/log/recovery/*
chown log:log /data/log/recovery
chown log:log /data/log/recovery/*

# save crash event into /data/log/history_event
reboot_mode=`getprop ro.boot.reboot_mode`
first_boot=`getprop ro.boot.firstboot`
event_maxline=80

if [ "${reboot_mode}" = "kernel_panic" ] || [ "${reboot_mode}" = "watchdog_reboot" ]
then
    echo -e "r${os_version}\t\t${reboot_mode}\t\t\t${timestamp}" >> ${event_file}
fi

if [ "${first_boot}" = "1" ]
then
    echo -e "r${os_version}\t\tfirst_boot\t\t\t\t${timestamp}" >> ${event_file}
fi

event_info=`wc -l ${event_file}`
event_count=${event_info%% *}
if [ ${event_maxline} -lt ${event_count} ]
then
    sed -i "1d" ${event_file}
fi
chmod 0664 ${event_file}
chown log:log ${event_file}
