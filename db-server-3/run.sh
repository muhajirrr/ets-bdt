HOSTNAME="db-server-3"
DBPASS="secret"

wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
sudo dpkg -i percona-release_latest.generic_all.deb

sudo apt-get update

sudo debconf-set-selections <<< "percona-xtradb-cluster-server-5.7 percona-xtradb-cluster-server-5.7/root-pass password $DBPASS"
sudo debconf-set-selections <<< "percona-xtradb-cluster-server-5.7 percona-xtradb-cluster-server-5.7/re-root-pass password $DBPASS"

sudo DEBIAN_FRONTEND=noninteractive apt-get install -q -y percona-xtradb-cluster-57

sudo service mysql stop

sudo cp "/vagrant/$HOSTNAME/wsrep.cnf" /etc/mysql/percona-xtradb-cluster.conf.d/wsrep.cnf

sudo service mysql start