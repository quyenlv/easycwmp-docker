FROM ubuntu:16.04
LABEL maintainer="gaimande@gmail.com"

# Install.
RUN apt-get update && \
mkdir -p /opt/dev && \
mkdir -p /opt/git && \
apt-get -y install git net-tools && \
git clone git://github.com/json-c/json-c.git /opt/git/json-c && \
cd /opt/git/json-c/ && \
apt-get install -y dh-autoreconf && \
apt-get install -y autoconf-archive && \
autoreconf -i && \
./configure --prefix=/usr && \
make && \
make install && \
ln -sf /usr/include/json-c /usr/include/json && \
git clone git://nbd.name/luci2/libubox.git /opt/git/libubox && \
cd /opt/git/libubox/ && \
apt-get install -y cmake && \
apt-get install -y apt-utils && \
apt-get install -y pkg-config && \
apt-get install -y libjson-c-dev && \
cmake CMakeLists.txt -DBUILD_LUA=OFF && \
make && \
make install && \
ln -sf /usr/local/lib/libubox.so /usr/lib/libubox.so && \
mkdir -p /usr/share/libubox && \
ln -sf /usr/local/share/libubox/jshn.sh /usr/share/libubox/jshn.sh && \
git clone git://nbd.name/uci.git /opt/git/uci && \
cd /opt/git/uci/ && \
cmake CMakeLists.txt -DBUILD_LUA=OFF && \
make && \
class="western" && \
make install && \
ln -sf /usr/local/bin/uci /sbin/uci && \
ln -sf /usr/local/lib/libuci.so /usr/lib/libuci.so && \
git clone git://nbd.name/luci2/ubus.git /opt/git/ubus && \
cd /opt/git/ubus/ && \
cmake CMakeLists.txt -DBUILD_LUA=OFF && \
make && \
make install && \
ln -sf /usr/local/sbin/ubusd /usr/sbin/ubusd && \
ln -sf /usr/local/lib/libubus.so /usr/lib/libubus.so && \
git clone https://github.com/pivasoftware/microxml.git /opt/git/microxml && \
cd /opt/git/microxml/ && \
autoconf -i && \
./configure --prefix=/usr --enable-threads --enable-shared --enable-static && \
make && \
make install && \
ln -sf /usr/lib/libmicroxml.so.1.0 /lib/libmicroxml.so && \
ln -sf /usr/lib/libmicroxml.so.1.0 /lib/libmicroxml.so.1 && \
cd /opt/dev/ && \
apt-get install -y wget && \
wget http://easycwmp.org/download/easycwmp-1.5.2.tar.gz && \
tar -xzvf easycwmp-1.5.2.tar.gz  && \
mv easycwmp-1.5.2 easycwmp && \
rm /opt/dev/easycwmp/ext/openwrt/config/easycwmp
ADD easycwmp /opt/dev/easycwmp/ext/openwrt/config/
RUN cd /opt/dev/easycwmp/ && \
apt-get install -y libcurl4-gnutls-dev && \
autoreconf -i && \
./configure --enable-debug --enable-devel --enable-acs=multi --enable-jsonc=1 && \
make && \
mkdir -p /usr/share/easycwmp/functions && \
mkdir -p /etc/easycwmp && \
ln -sf /opt/dev/easycwmp/ext/openwrt/scripts/easycwmp.sh /usr/sbin/easycwmp && \
ln -sf /opt/dev/easycwmp/ext/openwrt/scripts/defaults /usr/share/easycwmp/defaults && \
ln -sf /opt/dev/easycwmp/ext/openwrt/scripts/functions/common/common /usr/share/easycwmp/functions/common && \
ln -sf /opt/dev/easycwmp/ext/openwrt/scripts/functions/common/device_info /usr/share/easycwmp/functions/device_info && \
ln -sf /opt/dev/easycwmp/ext/openwrt/scripts/functions/common/management_server /usr/share/easycwmp/functions/management_server && \
ln -sf /opt/dev/easycwmp/ext/openwrt/scripts/functions/common/ipping_launch /usr/share/easycwmp/functions/ipping_launch && \
ln -sf /opt/dev/easycwmp/ext/openwrt/scripts/functions/tr181/root /usr/share/easycwmp/functions/root && \
ln -sf /opt/dev/easycwmp/ext/openwrt/scripts/functions/tr181/ip /usr/share/easycwmp/functions/ip && \
ln -sf /opt/dev/easycwmp/ext/openwrt/scripts/functions/tr181/ipping_diagnostic /usr/share/easycwmp/functions/ipping_diagnostic && \
chmod +x /opt/dev/easycwmp/ext/openwrt/scripts/functions/* && \
mkdir /etc/config && \
ln -sf /opt/dev/easycwmp/ext/openwrt/config/easycwmp /etc/config/easycwmp && \
ln -sf /opt/dev/easycwmp/bin/easycwmpd /usr/sbin/easycwmpd && \
export UCI_CONFIG_DIR="/opt/dev/easycwmp/ext/openwrt/config/" && \
export UBUS_SOCKET="/var/run/ubus.sock" && \
mkdir -p /lib/config && \
mkdir -p /lib/functions && \
wget http://pastebin.lukaperkov.net/openwrt/20121219_lib_functions.sh -O /lib/functions.sh  && \
wget http://pastebin.lukaperkov.net/openwrt/20121219_lib_config_uci.sh -O /lib/config/uci.sh && \
wget http://pastebin.lukaperkov.net/openwrt/20121219_lib_functions_network.sh -O /lib/functions/network.sh && \
export PATH=$PATH:/usr/sbin:/sbin && \
ln -sf bash /bin/sh
ADD startup.sh /

ENTRYPOINT ["sh"] 
CMD ["/startup.sh"]
