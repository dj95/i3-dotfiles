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
      # Muted 1 = muted, 2 = vol, 4-6 = essid, 7 = wlan_ip, 9 = eth_ip, 11 = bat_perc, 12 = bat_time, 14 = date, 15 = time  
      # Unmuted 1 = vol, 3-5 = essid, 6 = wlan_ip, 8 = eth_ip, 10 = bat_perc, 11 = bat_time, 13 = date, 14 = time  
      
      sys_arr=(${line#???})
      
      if [[ "${sys_arr[1]}" == "muted" ]]; then
          # date
          time="%{F$DATE_BG}%{B$BAT_BG}$SEP_LEFT%{F$DATE_FG}%{B$DATE_BG}  ${sys_arr[${#sys_arr[@]}-2]} $SEP_LEFT_SLIM ${sys_arr[${#sys_arr[@]}-1]}"

          # volume
          sys_arr[2]=${sys_arr[2]#?}
          vol="%{F$VOL_BG}%{B#3D3D3D}$SEP_LEFT%{F${VOL_FG}}%{B${VOL_BG}}  ${sys_arr[2]::-1}"

          # network
          if [[ ${sys_arr[9]} != "down" ]] && [[ ${sys_arr[4]} != "down" ]]; then # both up
              net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F$NET_FG}%{B$NET_BG}  ${sys_arr[7]} ${sys_arr[4]} ${sys_arr[5]} ${sys_arr[6]} $SEP_LEFT_SLIM  ${sys_arr[9]} "
          
              # battery
              battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${sys_arr[13]}"
          elif [[ ${sys_arr[6]} == "down" ]] && [[ ${sys_arr[4]} == "down" ]]; then # both down
              net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT"
          
              # battery
              battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${sys_arr[8]}"
          elif [[ ${sys_arr[9]} == "down" ]] && [[ ${sys_arr[4]} != "down" ]]; then # wifi only
              net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F$NET_FG}%{B$NET_BG}  ${sys_arr[7]} ${sys_arr[4]} ${sys_arr[5]} ${sys_arr[6]} "
          
              # battery
              battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${sys_arr[11]}"
          elif [[ ${sys_arr[9]} != "down" ]] && [[ ${sys_arr[4]} == "down" ]]; then # eth only
              net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F$NET_FG}%{B$NET_BG}  ${sys_arr[6]} "
          
              # battery
              battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${sys_arr[10]}"
          fi
      else
          # date
          time="%{F$DATE_BG}%{B$BAT_BG}$SEP_LEFT%{F$DATE_FG}%{B$DATE_BG}  ${sys_arr[${#sys_arr[@]}-2]} $SEP_LEFT_SLIM ${sys_arr[${#sys_arr[@]}-1]}"
      
          # volume
          vol="%{F$VOL_BG}%{B#3D3D3D}$SEP_LEFT%{F${VOL_FG}}%{B${VOL_BG}}  ${sys_arr[1]}"

          # network
          if [[ ${sys_arr[8]} != "down" ]] && [[ ${sys_arr[3]} != "down" ]]; then # both up
              net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F$NET_FG}%{B$NET_BG}  ${sys_arr[6]} ${sys_arr[3]} ${sys_arr[4]} ${sys_arr[5]} $SEP_LEFT_SLIM  ${sys_arr[8]} "
          
              # battery
              battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${sys_arr[12]}"
          elif [[ ${sys_arr[5]} == "down" ]] && [[ ${sys_arr[3]} == "down" ]]; then # both down
              net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT"
          
              # battery
              battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${sys_arr[7]}"
          elif [[ ${sys_arr[8]} == "down" ]] && [[ ${sys_arr[3]} != "down" ]]; then # wifi only
              net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F$NET_FG}%{B$NET_BG}  ${sys_arr[6]} ${sys_arr[3]} ${sys_arr[4]} ${sys_arr[5]} "
          
              # battery
              battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${sys_arr[10]}"
          elif [[ ${sys_arr[8]} != "down" ]] && [[ ${sys_arr[3]} == "down" ]]; then # eth only
              net="%{F$NET_BG}%{B$VOL_BG}$SEP_LEFT%{F$NET_FG}%{B$NET_BG}  ${sys_arr[5]} "
          
              # battery
              battery="%{F$BAT_BG}%{B$NET_BG}$SEP_LEFT%{F$BAT_FG}%{B$BAT_BG}  ${sys_arr[9]}"
          fi
      fi
      ;;
    BGN*)
      bgn="%{F$BGN_FG}%{B$BGN_BG} ${line#???}"
      ;;
    WSP*)
      wsp=${line#???} 
      ;;
    WIN*)
      title="%{F$WIN_FG}%{B$WIN_BG}${line#???} %{F$WIN_BG}%{B$BG}$SEP_RIGHT" 
      ;;
  esac

  printf "%s\n" "%{l}${bgn} ${wsp} %{r}%{F#3D3D3D}%{B$BG}$SEP_LEFT${vol} ${net}${battery} ${time} %{B${BG}}"
done
