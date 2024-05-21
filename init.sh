#!/bin/bash  

download_path="https://cdndown.kd0518.com/download/packages"
ddd=`yum install -y docker`
echo $ddd
setenforce 0
sleep 5

nohup service docker restart >/dev/null 2>&1 &

sleep 10

mkdir -p /data/docker
cd /data/docker
wget $download_path/Dockerfile
docker build -t nginx:v1 .

sleep 60

wget $download_path/nginx.tar.gz
tar -xvf nginx.tar.gz

cd /data/docker/nginx
mkdir -p /data/docker/nginx/cache
docker run -d -p 80:80 -p 443:443 --privileged=true -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf -v $PWD/ssl:/ssl -v $PWD/conf/conf.d:/etc/nginx/conf.d -v /etc/localtime:/etc/localtime -v $PWD/www:/www -v /etc/timezone:/etc/timezone -v $PWD/logs:/var/log/nginx -v $PWD/cache:/cache -v $PWD/geoip:/geoip --name mynginx nginx:v1

cd /data/baixun
#wget $download_path/net_bandwidth_traffic.sh
#wget $download_path/ssl.sh
#wget $download_path/update_waf_os.sh
#wget $download_path/update_geoip2_country.sh
#wget $download_path/restart_nginx.sh
#wget $download_path/docker_nginx_log.sh
#wget $download_path/cpu_loadavg.sh
#wget $download_path/create_crontab.sh

#wget http://manage.bxyun.cn/download/nginx/master/logstash-7.2.0.tar.gz
#tar -xvf logstash-7.2.0.tar.gz

#cd /etc/logrotate.d
#wget $download_path/docker_nginx
 
rm -rf /tmp/init.pid

yum install -y net-tools
echo "安装route成功"

yum install -y iptables-services
echo "安装iptables成功"

#mkdir -p /data/docker/nginx/ssl
#mkdir -p /data/docker/nginx/www
mkdir -p /var/log/letsencrypt
mkdir -p /etc/letsencrypt
mkdir -p /var/lib/letsencrypt
#mkdir -p /data/docker/nginx/www
#mkdir -p /data/tomcat/tomcat-loco999
#mkdir -p /data/docker/nginx/rtmp/hls
#mkdir -p /data/docker/nginx/rtmp/conf

docker pull certbot/certbot
echo "安装 certbot 成功"

yum install nc -y
echo "安装 nc 成功"

yum install bind-utils -y
echo "安装 dig 成功"

echo "init success" 

