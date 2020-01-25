#!/bin/sh

if [ ! -f /etc/nginx/conf.d/onetls.stream.lock ]; then
	nginx_domain=${NGINX_DOMAIN:-"example.com"}
	snell_domain=${SNELL_DOMAIN:-"snell.example.com"}
	shadowsocks_domain=${SHADOWSOCKS_DOMAIN:-"shadowsocks.example.com"}
	gost_domain=${GOST_DOMAIN:-"gost.example.com"}
	cat > /etc/nginx/conf.d/onetls.stream <<EOF
log_format onetls '\$remote_addr [\$time_local] '
                  '\$protocol \$status \$bytes_sent \$bytes_received '
                  '\$session_time \$ssl_preread_server_name \$ssl_preread_protocol [\$ssl_preread_alpn_protocols] ';

map \$ssl_preread_server_name \$backend {
	${snell_domain} snell;
	${shadowsocks_domain} shadowsocks;
	${gost_domain} gost;
	default nginx;
}

upstream snell {
	server snell:443;
}

upstream shadowsocks {
	server shadowsocks:443;
}

upstream gost {
	server gost:443;
}

upstream nginx {
	server ${nginx_domain}:443;
}

server {
	listen      443;
	listen      443 udp;
	access_log  /var/log/nginx/onetls.access.log onetls;
	proxy_pass  \$backend;
	ssl_preread on;
}
EOF
	cat > /etc/nginx/conf.d/onetls.http <<EOF
server {
	listen 80;
	rewrite ^/(.*) https://${nginx_domain}/\$1 redirect;
}
EOF
fi

nginx -g "daemon off;"