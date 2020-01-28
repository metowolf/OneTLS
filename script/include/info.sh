#!/bin/sh

_info_global() {
    echo ""
    echo "\t${BOLD}Global${RESET}"
    echo "\t-------------"
    echo "\tserver:   ${BOLD}${ONETLS_IP}:443${RESET}"
    echo "\tDNS:      ${BOLD}${ONETLS_DNS}${RESET}"
    echo "\tObfs url: ${BOLD}${NGINX_DOMAIN}${RESET}"
}

_info_shadowsocks() {
    if [[ ! ${SHADOWSOCKS_DOMAIN} =~ ^_. ]]; then
        echo ""
        echo "\t${BOLD}Shadowsocks${RESET}"
        echo "\t-------------"
        echo "\tmethod:    ${BOLD}${SHADOWSOCKS_METHOD}${RESET}"
        echo "\tpassword:  ${BOLD}${SHADOWSOCKS_PASSWORD}${RESET}"
        echo "\tobfs type: ${BOLD}tls${RESET}"
        echo "\tobfs url:  ${BOLD}${SHADOWSOCKS_DOMAIN}${RESET}"
    fi
}

_info_snell() {
    if [[ ! ${SNELL_DOMAIN} =~ ^_. ]]; then
        echo ""
        echo "\t${BOLD}Snell${RESET}"
        echo "\t-------------"
        echo "\tpsk:       ${BOLD}${SNELL_PASSWORD}${RESET}"
        echo "\tobfs type: ${BOLD}tls${RESET}"
        echo "\tobfs url:  ${BOLD}${SNELL_DOMAIN}${RESET}"
    fi
}

_info_gost() {
    if [[ ! ${GOST_DOMAIN} =~ ^_. ]]; then
        echo ""
        echo "\t${BOLD}SOCKS5-TLS${RESET}"
        echo "\t-------------"
        echo "\tusername:  ${BOLD}${GOST_USERNAME}${RESET}"
        echo "\tpassword:  ${BOLD}${GOST_PASSWORD}${RESET}"
        echo "\ttls sni:   ${BOLD}${GOST_DOMAIN}${RESET}"
    fi
}

_info_load_env() {
    if [ ! -f ${onetls_dir}/.env ]; then
        warning "Please install first!"
        exit 1
    fi
    source ${onetls_dir}/.env
}

_info_load_ip() {
    ONETLS_IP=`wget -qO- -t1 -T2 api.ip.sb/ip`
}

menu_info() {
    _info_load_env
    _info_load_ip
    _info_global
    _info_shadowsocks
    _info_snell
    _info_gost
    echo ""
}