#! /bin/sh
### BEGIN INIT INFO
# Provides:          glusterfs-server
# Required-Start:    $local_fs $remote_fs $network
# Required-Stop:     $local_fs $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: GlusterFS server
# Description:       GlusterFS is a cluster filesystem. This service
#                    provides the GlusterFS server functionality which
#                    is configured using the 'gluster' command.
### END INIT INFO

# Author: Chris AtLee <chris@atlee.ca>
# Patched by: Matthias Albert < matthias@linux4experts.de>

PATH=/sbin:/usr/sbin:/bin:/usr/bin
NAME=glusterd
SCRIPTNAME=/etc/init.d/$NAME
DAEMON=/usr/sbin/$NAME
PIDFILE=/var/run/$NAME.pid
GLUSTERD_OPTS="--no-daemon --volfile=/etc/glusterfs/glusterd.vol --log-file=-"
PID=`test -f $PIDFILE && cat $PIDFILE`


# Gracefully exit if the package has been removed.
test -x $DAEMON || exit 0

# Define LSB log_* functions.
. /lib/lsb/init-functions


do_start()
{
    pidofproc -p $PIDFILE $DAEMON >/dev/null
    status=$?
    if [ $status -eq 0 ]; then
      log_success_msg "glusterd service is already running with pid $PID"
    else
      log_daemon_msg "Starting glusterd service" "glusterd"
      $DAEMON -p $PIDFILE $GLUSTERD_OPTS
      log_end_msg $?
    fi
}

do_stop()
{
    log_daemon_msg "Stopping glusterd service" "glusterd"
    start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE
    log_end_msg $?
    rm -f $PIDFILE
    killproc -p $PIDFILE $DAEMON
    return $?
}

do_status()
{
     pidofproc -p $PIDFILE $DAEMON >/dev/null
     status=$?
     if [ $status -eq 0 ]; then
       log_success_msg "glusterd service is running with pid $PID"
     else
       log_failure_msg "glusterd service is not running."
     fi
     exit $status
}

case "$1" in
  start)
        do_start
        ;;
  stop)
        do_stop
        ;;
  status)
        do_status;
        ;;
  restart|force-reload)
        do_stop
        sleep 2
        do_start
        ;;
  *)
        echo "Usage: $SCRIPTNAME {start|stop|status|restart|force-reload}" >&2
        exit 3
        ;;
esac
