FROM centos:7.6.1810

RUN ping -c 1 www.baidu.com
RUN yum -y install openssl openssl-devel  wget gcc make pcre-devel zlib-devel tar zlib

RUN mkdir /nginx
WORKDIR /nginx
RUN wget --no-check-certificate https://raw.githubusercontent.com/P3TERX/GeoLite.mmdb/download/GeoLite2-Country.mmdb
# 如果 wget 不能使用，那么，换成 wget --no-check-certificate 试试

RUN mkdir /data
WORKDIR /data
RUN wget https://codeload.github.com/maxmind/libmaxminddb/tar.gz/refs/tags/1.9.1
RUN tar -xzf libmaxminddb-1.9.1.tar.gz
WORKDIR libmaxminddb-1.9.1
RUN ./configure
RUN make && make install
RUN sh -c "echo /usr/local/lib  >> /etc/ld.so.conf.d/local.conf"
RUN ldconfig
RUN  mkdir -p /var/cache/nginx/
WORKDIR /data
RUN wget https://codeload.github.com/leev/ngx_http_geoip2_module/tar.gz/refs/tags/3.4
RUN  tar -zxvf ngx_http_geoip2_module-3.4.tar.gz
RUN wget https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz
RUN tar -zxvf 2.3.tar.gz 


RUN wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz
RUN tar -xvf LuaJIT-2.0.5.tar.gz
WORKDIR /data/LuaJIT-2.0.5
RUN make && make install

WORKDIR /data
RUN wget https://github.com/openresty/lua-nginx-module/archive/v0.10.15.tar.gz
RUN tar -xvf v0.10.15.tar.gz
RUN export LUAJIT_LIB=/usr/local/lib
RUN export LUAJIT_INC=/usr/local/include/luajit-2.0
RUN ln -s /usr/local/lib/libluajit-5.1.so.2 /lib64/libluajit-5.1.so.2



RUN wget http://nginx.org/download/nginx-1.22.0.tar.gz
RUN tar -zxvf nginx-1.22.0.tar.gz
WORKDIR nginx-1.22.0
RUN ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --add-dynamic-module=/data/ngx_http_geoip2_module-3.4 --add-module=/data/ngx_cache_purge-2.3 --add-dynamic-module=/data/lua-nginx-module-0.10.15  --with-cc-opt='-g -O2 -fdebug-prefix-map=/data/builder/debuild/nginx-1.22.0/debian/debuild-base/nginx-1.22.0=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie'

RUN make && make install

RUN useradd -s /sbin/nologin -M nginx
RUN mkdir -p /var/tmp/nginx/client/
EXPOSE 443
EXPOSE 80
CMD /bin/sh -c 'nginx -g "daemon off;"'
