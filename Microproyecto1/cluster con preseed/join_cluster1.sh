cd /vagrant/

file="/vagrant/certi.txt"

certification=$(cat "$file")

echo "$certification"

cat <<TEST> /home/vagrant/clusterconf.yaml
cluster:
  server_name: server1
  enabled: true
  server_address: 192.168.100.8:8443
  cluster_address: 192.168.100.7:8443
  cluster_certificate: |
     "$certification"
  cluster_password: admin
  member_config:
  - entity: storage-pool
    name: local
    key: source
    value: ""
TEST

cat /home/vagrant/clusterconf.yaml

sleep 10

echo "agregando certificado al preseed"

cat /home/vagrant/clusterconf.yaml | lxd init --preseed