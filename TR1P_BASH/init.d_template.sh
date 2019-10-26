#!/usr/bin/env bash
### BEGIN INIT INFO
# Provides:          DankMemes 
# Required-Start:    $local_fs $network 
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: stuff I want before startx
# Description:       derp
### END INIT INFO
screen -dms "over9000" /usr/bin/dankMEMEZ.sh
