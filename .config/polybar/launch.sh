#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
polybar main &
polybar main2 &
# Only open other bars if display is not cloned (Only 1 monitor positioned at 0x0)
if [ "$(xrandr | grep '+0+0 (' -c)" -le 1 ];
then
	polybar hdmi &
	polybar hdmi2 &
	polybar dp &
	polybar dp11 &
	polybar dp128 &
fi

echo "Polybar launched..."
