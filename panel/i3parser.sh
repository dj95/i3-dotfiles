#!/bin/bash
#
# Input parser for i3 lemon bar
# © 2015 Daniel Jankowski

# config
BGN_FG="#BDBDBD"
BGN_BG="#1D1D1D"

WS_BG="#000000"

WIN_FG="#BDBDBD"
WIN_BG="#1D1D1D"

VOL_FG="#BDBDBD"
VOL_BG="#1D1D1D"

NET_FG="#BDBDBD"
NET_BG="#1D1D1D"

BAT_FG="#BDBDBD"
BAT_BG="#1D1D1D"

DATE_FG="#BDBDBD"
DATE_BG="#1D1D1D"

BG="#00000000"

SEP_RIGHT=""
SEP_LEFT=""
SEP_RIGHT_SLIM=""
SEP_LEFT_SLIM=""

while read -r line ; do
  case $line in
    SYS*)
      sys_arr=${line#???}
      IFS="°" read t vol wlan eth bat date <<< $sys_arr

      # date
      date=($date)
      time="%{F$DATE_BG}%{B$BAT_BG}$SEP_LEFT%{F$DATE_FG}%{B$DATE_BG} ${date[0]}  ${date[1]}"

      # volume
      vol="%{F$VOL_BG}%{B#1D1D1D}$SEP_LEFT%{F#5D5D5D} V: %{F${VOL_FG}}%{B${VOL_BG}}${vol}"
      vol="${vol::-1}"

      # network
      if [[ ${wlan} != "down " ]] && [[ ${eth} != "down " ]]; then # both up
          net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F#5D5D5D} W: %{F$NET_FG}%{B$NET_BG}$wlan  %{F#5D5D5D}E:%{F$NET_FG} ${eth}"
      
          # battery
          battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F#5D5D5D} B:%{F$BAT_FG}%{B$BAT_BG}${bat:4}"
          battery="${battery::-1}"
      elif [[ ${wlan} == "down " ]] && [[ ${eth} == "down " ]]; then # both down
          net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT"
      
          # battery
          battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F#5D5D5D} B:%{F$BAT_FG}%{B$BAT_BG}${bat:4}"
          battery="${battery::-1}"
      elif [[ ${eth} == "down " ]] && [[ ${wlan} != "down " ]]; then # wifi only
          net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F#5D5D5D} W: %{F$NET_FG}%{B$NET_BG}${wlan}"

          # battery
          battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F#5D5D5D} B:%{F$BAT_FG}%{B$BAT_BG}${bat:4}"
          battery="${battery::-1}"
      elif [[ ${eth} != "down " ]] && [[ ${wlan} == "down " ]]; then # eth only
          net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F#5D5D5D} E: %{F$NET_FG}%{B$NET_BG}${eth}"
      
          # battery
          battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F#5D5D5D} B:%{F$BAT_FG}%{B$BAT_BG}${bat:4}"
          battery="${battery::-1}"
      fi
      ;;
    WSP*)
      wsp=${line#???} 
      ;;
    WIN*)
      title="%{F$WIN_FG}%{B$WIN_BG}${line#???} %{F$WIN_BG}%{B$BG}$SEP_RIGHT" 
      ;;
  esac

  printf "%s\n" "%{l} ${USER}@${HOSTNAME} ${wsp} %{r}${vol} ${net}${battery} ${time} %{B${BG}}"
done
