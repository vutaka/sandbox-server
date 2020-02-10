sudo systemctl stop tomcat
sudo zip /home/ec2-user/`date "+%Y%m%d_%H%M%S"`log.zip -r /var/log/app
sudo rm -f /var/log/app/*/*.log
sudo rm -f /var/log/app/*/*.old