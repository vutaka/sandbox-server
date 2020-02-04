
LOG_DIR="/var/log/app/system"
while true; do
  # Do something
  mpstat -P ALL >> $LOG_DIR/mpstat.log
  echo `date '+%Y-%m-%d %H:%M:%S'` `cat /proc/net/dev | grep eth0 | sed -e 's/:/ /' | awk '{print$10}'` >> $LOG_DIR/nic.log
  ps axo "user,pid,vsz,rss,command"|grep tomcat >> $LOG_DIR/ps.log
  vmstat >> $LOG_DIR/vmstat.log
  sleep 5;
done