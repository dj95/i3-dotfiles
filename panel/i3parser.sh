#!/bin/bash
#
# Input parser for i3 lemon bar
# © 2015 Daniel Jankowski

# config
BGN_FG="#1D1D1D"
BGN_BG="#b5bd68"

WS_BG="#000000"

WIN_FG="#BDBDBD"
WIN_BG="#1D1D1D"

VOL_FG="#BDBDBD"
VOL_BG="#2B2B2B"

NET_FG=$BGN_BG
NET_BG="#3D3D3D"

BAT_FG=$WIN_FG
BAT_BG=$WIN_BG

DATE_FG=$BGN_FG
DATE_BG=$BGN_BG

BG="#1D1D1D"

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
      time="%{F$DATE_BG}%{B$BAT_BG}$SEP_LEFT%{F$DATE_FG}%{B$DATE_BG}  ${date[0]} $SEP_LEFT_SLIM ${date[1]}"

      # volume
      vol="%{F$VOL_BG}%{B#3D3D3D}$SEP_LEFT%{F${VOL_FG}}%{B${VOL_BG}}  ${vol}"
      vol="${vol::-1}"

      # network
      if [[ ${wlan} != "down " ]] && [[ ${eth} != "down " ]]; then # both up
          net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F$NET_FG}%{B$NET_BG}  $wlan $SEP_LEFT_SLIM  ${eth}"
      
          # battery
          battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${bat:4}"
          battery="${battery::-1}"
      elif [[ ${wlan} == "down " ]] && [[ ${eth} == "down " ]]; then # both down
          net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT"
      
          # battery
          battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${bat:4}"
          battery="${battery::-1}"
      elif [[ ${eth} == "down " ]] && [[ ${wlan} != "down " ]]; then # wifi only
          net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F$NET_FG}%{B$NET_BG}  ${wlan}"

          # battery
          battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${bat:4}"
          battery="${battery::-1}"
      elif [[ ${eth} != "down " ]] && [[ ${wlan} == "down " ]]; then # eth only
          net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F$NET_FG}%{B$NET_BG}  ${eth}"
      
          # battery
          battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${bat:4}"
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

  printf "%s\n" "%{l}%{F$BGN_FG}%{B$BGN_BG}  ${wsp} %{r}%{F#3D3D3D}%{B$BG}$SEP_LEFT${vol} ${net}${battery} ${time} %{B${BG}}"
done
