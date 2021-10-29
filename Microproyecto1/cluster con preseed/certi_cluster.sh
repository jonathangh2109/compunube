cd /vagrant

cat preseed.yaml | lxd init --preseed

certification=$(sed ':a;N;$!ba;s/\n/\n\n/g' /var/lib/lxd/cluster.crt)

touch certi.txt

echo "$certification" >> "certi.txt"