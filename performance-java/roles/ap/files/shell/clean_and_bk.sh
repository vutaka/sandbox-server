zip /home/ec2-user/`date "+%Y%m%d_%H%M%S"`log.zip -r /var/log/app
rm -f /var/log/app/*/*.log