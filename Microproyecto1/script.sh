echo "configurando puente para conectividad entre contenedores"

sudo lxc network set lxdfan0 "fan.underlay_subnet" "192.168.100.0/24" 

echo "configurado fan.underlay_subnet"

echo "creando contenedores"

lxc init ubuntu:18.04 haproxy --target balanceadora
lxc init ubuntu:18.04 server1 --target servers1
lxc init ubuntu:18.04 server2 --target servers2
lxc init ubuntu:18.04 server3 --target servers1
lxc init ubuntu:18.04 server4 --target servers2

echo "contenedores creados"

echo "configurando haproxy"
lxc start haproxy
lxc exec haproxy -- apt-get update -y
lxc exec haproxy -- apt-get install -y haproxy
lxc exec haproxy -- systemctl enable haproxy


echo "haproxy configurado"

echo "configurando apache en servers"
lxc start server1
lxc exec server1 -- apt-get update -y
lxc exec server1 -- apt-get install -y apache2
lxc exec server1 -- systemctl enable apache2


lxc start server2
lxc exec server2 -- apt-get update -y
lxc exec server2 -- apt-get install -y apache2
lxc exec server2 -- systemctl enable apache2


lxc start server3
lxc exec server3 -- apt-get update -y
lxc exec server3 -- apt-get install -y apache2
lxc exec server3 -- systemctl enable apache2


lxc start server4
lxc exec server4 -- apt-get update -y
lxc exec server4 -- apt-get install -y apache2
lxc exec server4 -- systemctl enable apache2

echo "apache configurado en los 4 servers"

