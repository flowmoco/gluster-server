#! /bin/sh 

dig +short $GLUSTER_SERVICE_NAME | while read line ; do gluster peer probe $line ; done
