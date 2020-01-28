#!/bin/bash

_info_global() {
    echo -e ""
    echo -e "\t${BOLD}Global${RESET}"
    echo -e "\t-------------"
    echo -e "\tserver:   ${BOLD}${ONETLS_IP}:443${RESET}"
    echo -e "\tDNS:      ${BOLD}${ONETLS_DNS}${RESET}"
    echo -e "\tObfs url: ${BOLD}${NGINX_DOMAIN}${RESET}"
}

_info_shadowsocks() {
    if [[ ! ${SHADOWSOCKS_DOMAIN} =~ ^_. ]]; then
        echo -e ""
        echo -e "\t${BOLD}Shadowsocks${RESET}"
        echo -e "\t-------------"
        echo -e "\tmethod:    ${BOLD}${SHADOWSOCKS_METHOD}${RESET}"
        echo -e "\tpassword:  ${BOLD}${SHADOWSOCKS_PASSWORD}${RESET}"
        echo -e "\tobfs type: ${BOLD}tls${RESET}"
        echo -e "\tobfs url:  ${BOLD}${SHADOWSOCKS_DOMAIN}${RESET}"
    fi
}

_info_snell() {
    if [[ ! ${SNELL_DOMAIN} =~ ^_. ]]; then
        echo -e ""
        echo -e "\t${BOLD}Snell${RESET}"
        echo -e "\t-------------"
        echo -e "\tpsk:       ${BOLD}${SNELL_PASSWORD}${RESET}"
        echo -e "\tobfs type: ${BOLD}tls${RESET}"
        echo -e "\tobfs url:  ${BOLD}${SNELL_DOMAIN}${RESET}"
    fi
}

_info_gost() {
    if [[ ! ${GOST_DOMAIN} =~ ^_. ]]; then
        echo -e ""
        echo -e "\t${BOLD}SOCKS5-TLS${RESET}"
        echo -e "\t-------------"
        echo -e "\tusername:  ${BOLD}${GOST_USERNAME}${RESET}"
        echo -e "\tpassword:  ${BOLD}${GOST_PASSWORD}${RESET}"
        echo -e "\ttls sni:   ${BOLD}${GOST_DOMAIN}${RESET}"
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
    echo -e ""
}