#!/bin/bash

pushd `dirname "$0"` > /dev/null
onetls_dir=`pwd`

. ./script/include/base.sh
. ./script/include/install.sh
. ./script/include/info.sh
. ./script/include/network.sh

copyright
while :;do
    echo -e ""
    if [ ! -f ${onetls_dir}/.env ]; then
        echo -e "\t${GREEN}1.${RESET} Install OneTLS"
    else
        echo -e "\t${GREEN}1.${RESET} ReInstall OneTLS"
    fi
    echo -e "\t-----"
    echo -e "\t${GREEN}2.${RESET} Start OneTLS"
    echo -e "\t${GREEN}3.${RESET} Stop OneTLS"
    echo -e "\t${GREEN}4.${RESET} Restart OneTLS"
    echo -e "\t-----"
    echo -e "\t${GREEN}5.${RESET} Show OneTLS Config"
    echo -e "\t${GREEN}6.${RESET} Show Network Usage Today"
    echo -e "\t-----"
    echo -e "\t${GREEN}q.${RESET} Exit"
    echo -e ""
    read -e -p "Please input the correct option: " Number
    if [[ ! "${Number}" =~ ^[1-6,q]$ ]]; then
        error "input error! Please only input 1~6 and q"
    else
        case "${Number}" in
            1)
                clear
                copyright
                menu_install
                menu_info
                ;;
            2)
                docker-compose up -d
                ;;
            3)
                docker-compose down
                ;;
            4)
                docker-compose down
                docker-compose up -d
                ;;
            5)
                clear
                copyright
                menu_info
                ;;
            6)
                clear
                copyright
                menu_network_usage
                ;;
            q)
                exit
                ;;
        esac
    fi
done