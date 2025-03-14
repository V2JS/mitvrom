#!/system/bin/sh

while read cmdline
do
	board_str=${cmdline#*platform_name=}
	codec_str=${cmdline#*aux_codec=}
	board=${board_str%% *}
	codec=${codec_str%% *}
done < /proc/cmdline
if [ -z $board ];then
	echo "unknown board"
	exit
fi
if [ -z $codec ];then
	echo "unknown codec"
	exit
fi
if [ "$codec" = "tas5707" ];then
	file="$board""_ti""_""$codec"".dts"
fi
if [ "$codec" = "tas5805" ];then
	file="$board""_ti""_""$codec"".dts"
fi
if [ "$codec" = "ad82584" ];then
	file="$board""_esmt""_""$codec""d"".dts"
fi
if [ "$codec" = "ad82088" ];then
	file="$board""_esmt""_""$codec"".dts"
fi
if [ "$codec" = "acm8625" ];then
	file="$board""_acm""_""$codec"".dts"
fi
if [ ! -f "/system/etc/codec_para/$file" ];then
	echo "$file doesn't exist"
else
	cat /system/etc/codec_para/$file > /sys/class/xiaomi-speaker/AMP/eq_param
	echo "eq $file done"
fi
