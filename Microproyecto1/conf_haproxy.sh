echo "reemplazando pagina error haproxy"

cd /vagrant/index/index5

lxc file push 503.http haproxy/etc/haproxy/errors/503.http

echo "adquiriendo ip server1"

lsde=$(lxc exec server1 -- ip a s eth0)

i1=$(echo "$lsde" | grep -Po '(?!(inet 127.\d.\d.1))(inet \K(\d{1,3}\.){3}\d{1,3})')

echo "$i1"

echo "adquiriendo ip server2"

lsde=$(lxc exec server2 -- ip a s eth0)

i2=$(echo "$lsde" | grep -Po '(?!(inet 127.\d.\d.1))(inet \K(\d{1,3}\.){3}\d{1,3})')

echo "adquiriendo ip server3"

lsde=$(lxc exec server3 -- ip a s eth0)

i3=$(echo "$lsde" | grep -Po '(?!(inet 127.\d.\d.1))(inet \K(\d{1,3}\.){3}\d{1,3})')

echo "adquiriendo ip server4"

lsde=$(lxc exec server4 -- ip a s eth0)

i4=$(echo "$lsde" | grep -Po '(?!(inet 127.\d.\d.1))(inet \K(\d{1,3}\.){3}\d{1,3})')


cat <<TEST> /home/vagrant/haproxy.cfg

global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	# An alternative list with additional directives can be obtained from
	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http



backend web-backend
   balance roundrobin
   stats enable
   stats auth admin:admin
   stats uri /haproxy?stats
   option allbackups
   server server1 $i1:80 check rise 3 fall 2
   server server2 $i2:80 check rise 3 fall 2
   server server3 $i3:80 check rise 3 fall 2 backup
   server server4 $i4:80 check rise 3 fall 2 backup

frontend http
  bind *:80
  default_backend web-backend
TEST

cat /home/vagrant/haproxy.cfg

sleep 10

echo "copiando archivo configuracion haproxy"

lxc file push /home/vagrant/haproxy.cfg haproxy/etc/haproxy/haproxy.cfg

lxc exec haproxy systemctl restart haproxy