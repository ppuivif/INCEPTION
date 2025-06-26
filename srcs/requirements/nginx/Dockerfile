FROM debian:bullseye

RUN apt-get update -y && \
	apt-get upgrade -y && \
    apt-get install -y nginx vim openssl && \
    mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=ppuivif.42.fr/UID=ppuivif"

RUN mkdir -p /var/run/nginx /var/www/html

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod -R 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]