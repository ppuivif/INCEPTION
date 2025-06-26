FROM debian:bullseye

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y php7.4-fpm \
	php7.4-mysql \
	curl \
	mariadb-client && \
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	test -f wp-cli.phar || (echo "[i] wp-cli.phar download failed" && exit 1) && \
	mv wp-cli.phar /usr/local/bin/wp && \
	chmod +x /usr/local/bin/wp && \
	apt-get purge -y curl && \
	apt-get autoremove -y && \
	m -rf /var/lib/apt/lists/*

COPY conf/wp.conf /etc/php/7.4/fpm/pool.d/wp.conf
COPY tools/wp.sh /usr/local/bin/wp.sh

RUN chmod +x /usr/local/bin/wp.sh

CMD ["/usr/local/bin/wp.sh"]