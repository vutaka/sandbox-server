MONITORING_PID=`ps -ef | grep resource_monitoring | grep -v grep | awk '{ print $2 }'`
kill -9 ${MONITORING_PID}