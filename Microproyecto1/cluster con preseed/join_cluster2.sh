cd /vagrant/

file="/vagrant/certi.txt"

certification=$(cat "$file")

echo "$certification"

cat <<TEST> /home/vagrant/clusterconf.yaml

config: {}

networks: []

storage_pools: []

profiles: []

cluster:

  server_name: server2

  enabled: true

  member_config:

  - entity: storage-pool

    name: local

    key: source

    value: ""

    description: '"source" property for storage pool "local"'

  cluster_address: 192.168.100.7:8443

  cluster_certificate:  |

	"$certification"

  server_address: 192.168.100.9:8443

  cluster_password: admin

TEST

cat /home/vagrant/clusterconf.yaml

sleep 10

echo "agregando certificado al preseed"

cat /home/vagrant/clusterconf.yaml | lxd init --preseed