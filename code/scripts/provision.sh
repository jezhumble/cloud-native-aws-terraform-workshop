#!/usr/bin/env bash

# install dependencies
amazon-linux-extras install lamp-mariadb10.2-php7.2
yum update -y
yum install -y httpd php php-mysqlnd php-mbstring php-bcmath php-xml awslogs

export HOME=/root

# configure apache httpd
rm /etc/httpd/conf.modules.d/00-dav.conf /etc/httpd/conf.modules.d/00-proxy.conf /etc/httpd/conf.modules.d/01-cgi.conf /etc/httpd/conf.modules.d/10-h2.conf /etc/httpd/conf.modules.d/10-proxy_h2.conf
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php.ini
aws s3 cp s3://jez-cloud-workshop/httpd.conf /etc/httpd/conf/httpd.conf
rm -rf /var/www/html
groupadd www
usermod -a -G www apache
chown -R ec2-user:www /var/www
find /var/www -type d -exec chmod 2750 {} +
find /var/www -type f -exec chmod 0640 {} +

# install cloudwatch
aws s3 cp s3://jez-cloud-workshop/cloudwatch.conf /etc/awslogs/awslogs.conf
systemctl enable awslogsd.service
systemctl start awslogsd

# configure autodeploy
aws s3 cp s3://jez-cloud-workshop/deploy.sh /home/ec2-user/deploy.sh
chown ec2-user /home/ec2-user/deploy.sh
chmod +x /home/ec2-user/deploy.sh
su ec2-user -c "/home/ec2-user/deploy.sh"
echo "* * * * * /home/ec2-user/deploy.sh" | crontab -u ec2-user -

# turn on httpd
systemctl enable httpd.service
systemctl start httpd
