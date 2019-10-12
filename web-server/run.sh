HOSTNAME="web-server"
DBPASS="secret"

wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
sudo dpkg -i percona-release_latest.generic_all.deb

sudo apt-get update

sudo apt-get install -y proxysql

sudo apt-get install -y percona-xtradb-cluster-client-5.7

mysql -u admin -padmin -h 127.0.0.1 -P 6032 -e "INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0, '192.168.16.105', 3306);"
mysql -u admin -padmin -h 127.0.0.1 -P 6032 -e "INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0, '192.168.16.106', 3306);"
mysql -u admin -padmin -h 127.0.0.1 -P 6032 -e "INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (0, '192.168.16.107', 3306);"

mysql -u admin -padmin -h 127.0.0.1 -P 6032 -e "UPDATE global_variables SET variable_value='proxysql_monitor' WHERE variable_name='mysql-monitor_username';"
mysql -u admin -padmin -h 127.0.0.1 -P 6032 -e "UPDATE global_variables SET variable_value='$DBPASS' WHERE variable_name='mysql-monitor_password';"
mysql -u admin -padmin -h 127.0.0.1 -P 6032 -e "INSERT INTO mysql_users (username,password) VALUES ('proxysql_user', '$DBPASS');"

mysql -u admin -padmin -h 127.0.0.1 -P 6032 -e "INSERT INTO scheduler (active,interval_ms,filename,arg1,comment)
    VALUES (1, 10000, '/usr/bin/proxysql_galera_checker', '--config-file=/etc/proxysql-admin.cnf', 'db-cluster');"

mysql -u admin -padmin -h 127.0.0.1 -P 6032 -e "SAVE MYSQL SERVERS TO DISK; SAVE MYSQL VARIABLES TO DISK; SAVE MYSQL USERS TO DISK; SAVE SCHEDULER TO DISK;"

sudo service proxysql restart