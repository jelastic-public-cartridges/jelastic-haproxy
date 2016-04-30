#!/bin/sh

source /etc/jelastic/environment

function _set_neighbors(){
    return 0;
}

function _rebuild_common(){
    su - jelastic -c "${CARTRIDGE_HOME}/versions/$Version/bin/haproxy -D -f ${CARTRIDGE_HOME}/versions/$Version/conf/haproxy.conf -p ${CARTRIDGE_HOME}/run/haproxy.pid -sf $(cat ${CARTRIDGE_HOME}/run/haproxy.pid)"
}

function _add_common_host(){
    grep -q "${host}:[0-9]* " ${CARTRIDGE_HOME}/versions/$Cartridge_Version/conf/haproxy.conf && return 0;
    count=$(cat ${CARTRIDGE_HOME}/versions/$Version/conf/haproxy.conf | grep -o "webserver[0-9]*" | sed 's/webserver//g' | sort -n | tail -n1);
    let "count+=1";
    sed -i "/backend bk_http ###HOSTS/a\server webserver${count} ${host}:80 cookie S${count} check" /opt/repo/versions/$Version/conf/haproxy.conf;
    su - jelastic -c "${CARTRIDGE_HOME}/versions/$Version/bin/haproxy -D -f ${CARTRIDGE_HOME}/versions/$Version/conf/haproxy.conf -p ${CARTRIDGE_HOME}/run/haproxy.pid -sf $(cat ${CARTRIDGE_HOME}/run/haproxy.pid)"
}



function _remove_common_host(){
    sed -i '/server.*webserver.*'${host}'/d' ${CARTRIDGE_HOME}/versions/$Cartridge_Version/conf/haproxy.conf;
    }


function _add_host_to_group(){
    return 0;
}

function _build_cluster(){
    return 0;
}

function _unbuild_cluster(){
    return 0;
}

function _clear_hosts(){
    return 0;
}

function _reload_configs(){
    return 0;
}
