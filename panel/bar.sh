#!/bin/bash
#
# I3 bar with https://github.com/LemonBoy/bar

#. $(dirname $0)/i3_lemonbar_config

# Configuration
panel_fifo="/dev/shm/i3_lemonbar_${USER}_2"

# look, if bar's already running
if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

# create fifo
[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"

# Host- and Username, "BGN"
echo "BGN" > "${panel_fifo}" &

# Window title, "WIN"
#xtitle -s | sed -unre 's/(.*)/WIN\1/p' > "${panel_fifo}" &

# i3 Workspaces, "WSP"
/home/neo/.i3/panel/i3ws.py > ${panel_fifo} &

# i3status, "SYS"
/opt/i3status/i3status > ${panel_fifo} &

# read from fifo into lemonbar
cat "${panel_fifo}" | /home/neo/.i3/panel/i3parser.sh \
  | lemonbar -B "#00232323" -f "Terminesspowerline-8" -f "Ionicons-8" -f "Serif-7"&

wait
