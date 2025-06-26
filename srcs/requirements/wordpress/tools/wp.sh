#!/bin/bash

mkdir -p /run/php

# echo "Waiting for MariaDB to be available..."
for i in {1..60}; do
    if mysqladmin ping -h "${WORDPRESS_DB_HOST}" -u "${MARIADB_USER}" "--password=${MARIADB_PASSWORD}" --silent; then
#        echo "MariaDB is up."
        break
    else
#        echo "MariaDB not available, retrying in 10 seconds..."
        sleep 10
    fi
done

mkdir -p /var/www/html
cd /var/www/html

if [ -f wp-config.php ]; then
	echo "wordpress already installed"
else

echo "Downloading WordPress core files..."
wp core download --allow-root

#echo "Generating wp-config.php..."
wp config create \
    --dbname=${WORDPRESS_DB_NAME} \
    --dbuser=${WORDPRESS_DB_USER} \
    --dbpass=${WORDPRESS_DB_PASSWORD} \
    --dbhost=${WORDPRESS_DB_HOST} \
    --allow-root

#echo "Installing WordPress..."
wp core install \
    --url=${WORDPRESS_URL} \
    --title="${TITLE}" \
    --admin_user=${WORDPRESS_ADMIN_USER} \
    --admin_password=${WORDPRESS_ADMIN_PWD} \
    --admin_email=${WORDPRESS_ADMIN_EMAIL} \
    --allow-root

#echo "Creating additional WordPress user..."
wp user create ${WORDPRESS_USER} ${WORDPRESS_USER_MAIL} --role=author --user_pass=${WORDPRESS_PASSWORD} --allow-root

chmod -R 775 wp-content

fi
# Start PHP-FPM
exec php-fpm7.4 -F