#Information Gathering

##Date
current_date=$(date "+%Y-%m-%d %H:%M:%S %p")

##Battery
battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | grep -E "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | grep -E "state" | awk '{print $2}')

##Sound Status
# https://unix.stackexchange.com/a/561305
#sound_status=$(pacmd list-sinks|grep -A 15 '* index'|awk '/muted:/{ print $2 }'| awk 'NR>0')
sound_status=$(pactl list sinks |grep Mute| awk '/Mute:/{print $2}') #$(pacmd list-sinks|grep -A 15 '* index'|awk '/muted:/{ print $2 }')
sound_volume=$(pactl list sinks |grep Volume|awk '/Volume: front-left:/{ print $5}'| sed 's/[%|,]//g') #$(pacmd list-sinks|grep -A 15 '* index'| awk '/volume: front/{ print $5 }' | sed 's/[%|,]//g')
mic_status=$(pactl list sink-inputs |grep Mute| awk '/Mute:/{print $2}') #$(pacmd list-sinks|grep -A 15 '* index'|awk '/muted:/{ print $2 }')


##Ethernet Status
ethernet_bitrate=$(cat /sys/class/net/enp0s31f6/speed)
ethernet_interface=enp0s31f6
ethernet_status=$(cat /sys/class/net/enp0s31f6/operstate)

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
if grep -q "yes" <<< "$sound_status";
then
    sound_status='🔇'
else
    sound_status='🔊'
fi

if [[ $mic_status == "yes" ]];
then
    mic_status='🙊'
else
    mic_status='🎤'
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

echo "🖴 $disk_usage | 🖧 $ethernet_interface $ethernet_status $ethernet_bitrate  | 📶$wifi_ap $wifi_bitrate $wifi_channel | $mic_status | $sound_status $sound_volume% | $charging_status $battery_charge | 🕘 $current_date "

