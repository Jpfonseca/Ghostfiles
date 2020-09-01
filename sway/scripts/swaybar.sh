#Information Gathering

##Date
current_date=$(date "+%Y-%m-%d %H:%M:%S %p")

##Battery
battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')

##Sound Status
# https://unix.stackexchange.com/a/561305
#sound_status=$(pacmd list-sinks|grep -A 15 '* index'|awk '/muted:/{ print $2 }'| awk 'NR>0')
sound_status=$(pacmd list-sinks|grep -A 15 '* index'|awk '/muted:/{ print $2 }')
sound_volume=$(pacmd list-sinks|grep -A 15 '* index'| awk '/volume: front/{ print $5 }' | sed 's/[%|,]//g')

##Ethernet Status
ethernet_bitrate=$(dmesg| grep enp2s0 | grep Up |awk '{print $10}' | head -n 1)
ethernet_interface=$(dmesg| grep enp2s0 | grep Up |awk '{print $5}' | head -n 1)
ethernet_status=$(cat /sys/class/net/enp2s0/operstate)

#Wifi Status
wifi_bitrate=$(iwconfig wlan0 |grep "Bit Rate"| awk '{print $2 $3}'|cut -d \= -f 2 ) 
wifi_channel=$(iwconfig wlan0 |grep "Frequency"| awk '{print $2 $3}'|cut -d \: -f 2)
wifi_ap=$(iwconfig wlan0 |grep "ESSID"| cut -d ':' -f 2)

##Disk Usage
disk_usage=$(df -h --output=avail / |tail -n 1)

#Logical Checks

##Battery
if [ $battery_status = "discharging" ];
then
    charging_status='🔋'
else
    charging_status='⚡'
fi

##Sound Status
if [ $sound_status = "yes" ];
then
    sound_status='🔇'
else
    sound_status='🔊'
fi

##Wifi Status
if [ $wifi_ap = "off/any" ];
then
    wifi_ap="disconnected"
    wifi_channel=""
fi

##Ethernet Status
if [ $ethernet_status = "down" ];
then
    ethernet_status="disconnected"
    ethernet_bitrate=""
fi

#Output

echo "🖴 $disk_usage | 🖧 $ethernet_interface $ethernet_status $ethernet_bitrate  | 📶$wifi_ap $wifi_bitrate $wifi_channel | $sound_status $sound_volume% | $charging_status $battery_charge | 🕘 $current_date "

