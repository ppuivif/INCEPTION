#!/bin/sh

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
fi

chmod 755 /run/mysqld

if ! chown -R mysql:mysql /run/mysqld; then
	echo "[!] Failed to change ownership of /run/mysqld — check permissions or user context" >&2
fi

if [ ! -d "/var/lib/mysql/${MARIADB_DATABASE}" ]; then
	if ! chown -R mysql:mysql /var/lib/mysql; then
		echo "[!] Failed to set ownership for MariaDB data directory" >&2
	fi

	tmpfile=$(mktemp)
	if [ ! -f "$tmpfile" ]; then
		echo "[!] Failed to create temp file"
		exit 1
	fi

    # Configuration database
    # Create User
    cat << EOF > $tmpfile
	USE mysql;
	FLUSH PRIVILEGES;
	GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' WITH GRANT OPTION;
	GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' WITH GRANT OPTION;
	CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};
	CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';
	FLUSH PRIVILEGES;
	EOF
	
	/usr/sbin/mysqld --user=mysql --bootstrap < $tmpfile
	rm -f $tmpfile
	# echo "[i] MariaDB setup complete."
fi

# echo "[i] Starting MariaDB server..."
# run database
exec /usr/sbin/mysqld --user=mysql --console --skip-networking=0 --bind-address=0.0.0.0