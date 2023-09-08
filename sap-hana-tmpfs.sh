#!/bin/bash
SID=HDB
COUNT=0
SIDADM=${SID,,}adm

start() {
	for each in $(ls -d /sys/devices/system/node/node*); do
		#
		mkdir -p /hana/tmpfs${COUNT}/${SID}
		mount tmpfs${SID}${COUNT} -t tmpfs -o mpol=prefer:${COUNT} /hana/tmpfs${COUNT}/${SID}
		COUNT=$((COUNT} + 1))
		chown -R $SIDADM:sapsys /hana/tmpfs*/${SID}
		chmod 777 -R /hana/tmpfs*/${SID}
	done
}

stop() {
	#
	for each in $(mount | grep '/hana/tmpfs' | awk '{ print $3 }'); do
		#
		umount $each
	done
}

# See how we were called.
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart|force-reload)
        stop
        start
        ;;
    reload)
	stop
	start
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|force-reload|reload}"
        exit 2
esac