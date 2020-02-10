sudo systemctl start tomcat
sleep 10
LOG_DIR="/var/log/app/system"
JAVA_PATH=`readlink -f $(which java)`
JAVA_HOME=`echo $JAVA_PATH | grep -oP "^.+(?=/jre/bin/java)"`
# PIDを特定する
TOMCAT_PID=`ps -ef | grep tomcat | grep -v grep | awk '{ print $2 }'`

while true; do
  # Do something
  mpstat -P ALL >> $LOG_DIR/mpstat.log
  echo `date '+%Y-%m-%d %H:%M:%S'` `cat /proc/net/dev | grep eth0 | sed -e 's/:/ /' | awk '{print$10}'` >> $LOG_DIR/nic.log
  ps axo "user,pid,vsz,rss,command"|grep tomcat >> $LOG_DIR/ps.log
  vmstat >> $LOG_DIR/vmstat.log
  echo `date '+%Y-%m-%d %H:%M:%S'` `$JAVA_HOME/bin/jstat -gc $TOMCAT_PID` >> $LOG_DIR/gc.log
  sleep 1;
done