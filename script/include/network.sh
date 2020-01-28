#!/bin/sh

_network_usage_detail() {
    echo "\t${BOLD}$1${RESET}"
    echo "\t-------------"
    count=`cat ${onetls_dir}/log/onetls.access.log | grep "$2" | wc -l | awk '{print $1}'`
    if [ "$count" = "0" ]; then
        echo "\tempty"
    else
        (
            printf "IP sent received \n"; \
            cat ${onetls_dir}/log/onetls.access.log \
            | grep "$2" \
            | awk '{print $1,$6,$7}' \
            | awk 'BEGIN { FS=OFS=SUBSEP=" "}{arr[$1][0]+=$2;arr[$1][1]+=$3 }END {for (i in arr) print i,arr[i][0],arr[i][1]}' \
            | sort -k2 -nr;
        ) | column -t -s $' ' | awk '$0="\t"$0'
    fi
    echo ""
}

menu_network_usage() {
    if [ ! -f ${onetls_dir}/.env ]; then
        warning "Please install first!"
        return
    fi
    source ${onetls_dir}/.env
    if [ -f ${onetls_dir}/log/onetls.access.log ]; then
        echo ""
        _network_usage_detail "Shadowsocks" " $SHADOWSOCKS_DOMAIN"
        _network_usage_detail "Snell" " $SNELL_DOMAIN"
        _network_usage_detail "SOCKS-TLS" " $GOST_DOMAIN"
    else
        warning "OneTLS log is empty!"
    fi
}