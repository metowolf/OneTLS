#!/bin/bash

_install_check_command() {
    if ! command_exists docker; then
        warning "Docker is not installed. Please install docker first."
		exit 1
	fi
    if ! command_exists docker-compose; then
        warning "Docker Compose is not installed. Please install docker-compose first."
		exit 1
	fi
}

_install_setup_global() {
    source ${onetls_dir}/.env.example
    if [ -f ${onetls_dir}/.env ]; then
        source ${onetls_dir}/.env
    fi
    while :; do
        read -e -p "Please input global DNS Server (default: ${BOLD}${ONETLS_DNS}${RESET}): " onetls_dns
        onetls_dns=${onetls_dns:-${ONETLS_DNS}}
        if (( ${#onetls_dns} >= 1 )); then
            ONETLS_DNS=${onetls_dns}
            break
        else
            warning "DNS Server could not be empty!"
        fi
    done
    while :; do
        read -e -p "Please input global obfs domain (default: ${BOLD}${NGINX_DOMAIN}${RESET}): " nginx_domain
        nginx_domain=${nginx_domain:-${NGINX_DOMAIN}}
        if (( ${#nginx_domain} >= 1 )); then
            NGINX_DOMAIN=${nginx_domain}
            break
        else
            warning "obfs domain could not be empty!"
        fi
    done
}

_install_setup_password_shadowsocks() {
    while :; do echo
        read -e -p "Do you want to enable shadowsocks? [y/n]: " shadowsocks_flag
        if [[ ! ${shadowsocks_flag} =~ ^[y,n]$ ]]; then
            warning "input error! Please only input 'y' or 'n'"
        else
            break
        fi
    done
    if [ "${shadowsocks_flag}" = 'y' ]; then
        # SHADOWSOCKS_PASSWORD
        while :; do
            read -e -p "Please input the password of shadowsocks (default: ${BOLD}${SHADOWSOCKS_PASSWORD}${RESET}): " shadowsocks_pwd
            shadowsocks_pwd=${shadowsocks_pwd:-${SHADOWSOCKS_PASSWORD}}
            [ -n "`echo ${shadowsocks_pwd} | grep '[+|&]'`" ] && { 
                warning "input error, not contain a plus sign (+) and &"; 
                continue;
            }
            if (( ${#shadowsocks_pwd} >= 6 )); then
                SHADOWSOCKS_PASSWORD=${shadowsocks_pwd}
                break
            else
                warning "password least 6 characters!"
            fi
        done
        # SHADOWSOCKS_METHOD
        while :; do
            read -e -p "Please input the encrypt method (default: ${BOLD}${SHADOWSOCKS_METHOD}${RESET}): " shadowsocks_method
            shadowsocks_method=${shadowsocks_method:-${SHADOWSOCKS_METHOD}}
            if (( ${#shadowsocks_method} >= 1 )); then
                SHADOWSOCKS_METHOD=${shadowsocks_method}
                break
            else
                warning "method could not be empty!"
            fi
        done
        # SHADOWSOCKS_DOMAIN
        while :; do
            read -e -p "Please input the obfs domain (default: ${BOLD}${SHADOWSOCKS_DOMAIN}${RESET}): " shadowsocks_domain
            shadowsocks_domain=${shadowsocks_domain:-${SHADOWSOCKS_DOMAIN}}
            [ -n "`echo ${shadowsocks_domain} | grep '[/]'`" ] && { 
                warning "input error, not contain character '/'"; 
                continue;
            }
            if (( ${#shadowsocks_domain} >= 1 )); then
                SHADOWSOCKS_DOMAIN=${shadowsocks_domain}
                break
            else
                warning "obfs domain could not be empty!"
            fi
        done
    else
        SHADOWSOCKS_PASSWORD=`openssl rand -hex 8`
        SHADOWSOCKS_METHOD='chacha20-ietf-poly1305'
        SHADOWSOCKS_DOMAIN="_.`openssl rand -hex 8`.com"
    fi
}

_install_setup_password_snell() {
    while :; do echo
        read -e -p "Do you want to enable snell? [y/n]: " snell_flag
        if [[ ! ${snell_flag} =~ ^[y,n]$ ]]; then
            warning "input error! Please only input 'y' or 'n'"
        else
            break
        fi
    done
    if [ "${snell_flag}" = 'y' ]; then
        # SNELL_PASSWORD
        while :; do
            read -e -p "Please input the token of snell (default: ${BOLD}${SNELL_PASSWORD}${RESET}): " snell_pwd
            snell_pwd=${snell_pwd:-${SNELL_PASSWORD}}
            [ -n "`echo ${snell_pwd} | grep '[+|&]'`" ] && { 
                warning "input error, not contain a plus sign (+) and &"; 
                continue;
            }
            if (( ${#snell_pwd} >= 6 )); then
                SNELL_PASSWORD=${snell_pwd}
                break
            else
                warning "password least 6 characters!"
            fi
        done
        # SNELL_DOMAIN
        while :; do
            read -e -p "Please input the obfs domain (default: ${BOLD}${SNELL_DOMAIN}${RESET}): " snell_domain
            snell_domain=${snell_domain:-${SNELL_DOMAIN}}
            [ -n "`echo ${snell_domain} | grep '[/]'`" ] && { 
                warning "input error, not contain character '/'"; 
                continue;
            }
            if (( ${#snell_domain} >= 1 )); then
                SNELL_DOMAIN=${snell_domain}
                break
            else
                warning "obfs domain could not be empty!"
            fi
        done
    else
        SNELL_PASSWORD=`openssl rand -hex 8`
        SNELL_DOMAIN="_.`openssl rand -hex 8`.com"
    fi
}

_install_setup_password_gost() {
    while :; do echo
        read -e -p "Do you want to enable gost(socks5 over tls)? [y/n]: " gost_flag
        if [[ ! ${gost_flag} =~ ^[y,n]$ ]]; then
            warning "input error! Please only input 'y' or 'n'"
        else
            break
        fi
    done
    if [ "${gost_flag}" = 'y' ]; then
        # GOST_USERNAME
        while :; do
            read -e -p "Please input the username of gost (default: ${BOLD}${GOST_USERNAME}${RESET}): " gost_username
            gost_username=${gost_username:-${GOST_USERNAME}}
            [ -n "`echo ${gost_username} | grep '[+|&]'`" ] && { 
                warning "input error, not contain a plus sign (+) and &"; 
                continue;
            }
            if (( ${#gost_username} >= 6 )); then
                GOST_USERNAME=${gost_username}
                break
            else
                warning "username least 6 characters!"
            fi
        done
        # GOST_PASSWORD
        while :; do
            read -e -p "Please input the password of gost (default: ${BOLD}${GOST_PASSWORD}${RESET}): " gost_pwd
            gost_pwd=${gost_pwd:-${GOST_PASSWORD}}
            [ -n "`echo ${gost_pwd} | grep '[+|&]'`" ] && { 
                warning "input error, not contain a plus sign (+) and &"; 
                continue;
            }
            if (( ${#gost_pwd} >= 6 )); then
                GOST_PASSWORD=${gost_pwd}
                break
            else
                warning "password least 6 characters!"
            fi
        done
        # GOST_DOMAIN
        while :; do
            read -e -p "Please input the obfs domain (default: ${BOLD}${GOST_DOMAIN}${RESET}): " gost_domain
            gost_domain=${gost_domain:-${GOST_DOMAIN}}
            [ -n "`echo ${gost_domain} | grep '[/]'`" ] && { 
                warning "input error, not contain character '/'"; 
                continue;
            }
            if (( ${#gost_domain} >= 1 )); then
                GOST_DOMAIN=${gost_domain}
                break
            else
                warning "obfs domain could not be empty!"
            fi
        done
    else
        GOST_USERNAME='onetls'
        GOST_PASSWORD=`openssl rand -hex 8`
        GOST_DOMAIN="_.`openssl rand -hex 8`.com"
    fi
}

_install_setup_password() {
    _install_setup_password_shadowsocks
    _install_setup_password_snell
    _install_setup_password_gost
}

_install_setup_env() {
    cp ${onetls_dir}/.env.example /tmp/onetls.env
    # global
    sed -i "s@^ONETLS_DNS=.*@ONETLS_DNS=${ONETLS_DNS}@g" /tmp/onetls.env
    # nginx
    sed -i "s@^NGINX_DOMAIN=.*@NGINX_DOMAIN=${NGINX_DOMAIN}@g" /tmp/onetls.env
    # shadowsocks
    sed -i "s@^SHADOWSOCKS_METHOD=.*@SHADOWSOCKS_METHOD=${SHADOWSOCKS_METHOD}@g" /tmp/onetls.env
    sed -i "s@^SHADOWSOCKS_PASSWORD=.*@SHADOWSOCKS_PASSWORD=${SHADOWSOCKS_PASSWORD}@g" /tmp/onetls.env
    sed -i "s@^SHADOWSOCKS_DOMAIN=.*@SHADOWSOCKS_DOMAIN=${SHADOWSOCKS_DOMAIN}@g" /tmp/onetls.env
    # snell
    sed -i "s@^SNELL_PASSWORD=.*@SNELL_PASSWORD=${SNELL_PASSWORD}@g" /tmp/onetls.env
    sed -i "s@^SNELL_DOMAIN=.*@SNELL_DOMAIN=${SNELL_DOMAIN}@g" /tmp/onetls.env
    # gost
    sed -i "s@^GOST_USERNAME=.*@GOST_USERNAME=${GOST_USERNAME}@g" /tmp/onetls.env
    sed -i "s@^GOST_PASSWORD=.*@GOST_PASSWORD=${GOST_PASSWORD}@g" /tmp/onetls.env
    sed -i "s@^GOST_DOMAIN=.*@GOST_DOMAIN=${GOST_DOMAIN}@g" /tmp/onetls.env
    mv /tmp/onetls.env ${onetls_dir}/.env
    cp ${onetls_dir}/docker-compose.example.yaml ${onetls_dir}/docker-compose.yaml
}

menu_install() {
    _install_check_command
    _install_setup_global
    _install_setup_password
    _install_setup_env
}