cd /vagrant/index/index1

lxc file push index.html server1/var/www/html/index.html

cd ..
cd index2

lxc file push index.html server2/var/www/html/index.html

cd ..
cd index3

lxc file push index.html server3/var/www/html/index.html 

cd ..
cd index4

lxc file push index.html server4/var/www/html/index.html