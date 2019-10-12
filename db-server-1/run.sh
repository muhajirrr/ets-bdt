HOSTNAME="db-server-1"
DBPASS="secret"

wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
sudo dpkg -i percona-release_latest.generic_all.deb

sudo apt-get update

sudo debconf-set-selections <<< "percona-xtradb-cluster-server-5.7 percona-xtradb-cluster-server-5.7/root-pass password $DBPASS"
sudo debconf-set-selections <<< "percona-xtradb-cluster-server-5.7 percona-xtradb-cluster-server-5.7/re-root-pass password $DBPASS"

sudo DEBIAN_FRONTEND=noninteractive apt-get install -q -y percona-xtradb-cluster-57

sudo service mysql stop

sudo cp "/vagrant/$HOSTNAME/wsrep.cnf" /etc/mysql/percona-xtradb-cluster.conf.d/wsrep.cnf

sudo /etc/init.d/mysql bootstrap-pxc

mysql -u root -p$DBPASS -e "CREATE USER 'sstuser'@'localhost' IDENTIFIED BY '$DBPASS'; GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost'; FLUSH PRIVILEGES;"

mysql -u root -p$DBPASS -e "CREATE USER 'proxysql_monitor'@'localhost' IDENTIFIED BY '$DBPASS'; GRANT USAGE ON *.* TO 'proxysql_monitor'@'localhost';"

mysql -u root -p$DBPASS -e "CREATE USER 'proxysql_user'@'192.168.16.104' IDENTIFIED BY '$DBPASS'; GRANT ALL ON *.* TO 'proxysql_user'@'192.168.16.104';"