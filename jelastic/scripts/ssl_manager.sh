#!/bin/bash

source /etc/jelastic/environment

function _enableSSL(){
        rm -f /var/lib/jelastic/SSL/jelastic.pem &>/dev/null;
        doAction keystore DownloadKeys;
        cat /var/lib/jelastic/SSL/jelastic.crt /var/lib/jelastic/SSL/jelastic.key >> /var/lib/jelastic/SSL/jelastic.pem;
        sed -i '/bind :::443/d' ${CARTRIDGE_HOME}/versions/$Version/conf/haproxy.conf;
        sed -i '/bind :::443/d' ${CARTRIDGE_HOME}/versions/$Version/haproxy.conf.default;
        sed -i '/bind :::80 v4v6/a bind :::443 v4v6 ssl crt /var/lib/jelastic/SSL/jelastic.pem' ${CARTRIDGE_HOME}/versions/$Version/conf/haproxy.conf;
        sed -i '/bind :::80 v4v6/a bind :::443 v4v6 ssl crt /var/lib/jelastic/SSL/jelastic.pem' ${CARTRIDGE_HOME}/versions/$Version/haproxy.conf.default;
        su - jelastic -c "${CARTRIDGE_HOME}/versions/$Version/bin/haproxy -D -f ${CARTRIDGE_HOME}/versions/$Version/conf/haproxy.conf -p ${CARTRIDGE_HOME}/run/haproxy.pid -sf $(cat ${CARTRIDGE_HOME}/run/haproxy.pid)"
}

function _disableSSL(){
        doAction keystore remove;
        rm -f /var/lib/jelastic/SSL/jelastic.pem &>/dev/null;
        sed -i '/bind :::443/d' ${CARTRIDGE_HOME}/versions/$Version/conf/haproxy.conf;
        sed -i '/bind :::443/d' ${CARTRIDGE_HOME}/versions/$Version/haproxy.conf.default;
        su - jelastic -c "${CARTRIDGE_HOME}/versions/$Version/bin/haproxy -D -f ${CARTRIDGE_HOME}/versions/$Version/conf/haproxy.conf -p ${CARTRIDGE_HOME}/run/haproxy.pid -sf $(cat ${CARTRIDGE_HOME}/run/haproxy.pid)"
}
