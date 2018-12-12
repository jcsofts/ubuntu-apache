FROM ubuntu:latest


RUN apt-get update && \
    apt-get -y install apache2 openssl && \
    openssl req \
	    -x509 \
	    -newkey rsa:2048 \
	    -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
	    -out /etc/ssl/certs/ssl-cert-snakeoil.pem \
	    -days 1024 \
	    -nodes \
	    -subj /CN=localhost && \
	mkdir /var/run/apache2 && \
	mkdir /var/log/php && \
	echo "ServerName localhost:80" >> /etc/apache2/apache2.conf && \
	apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_* && \
    rm -f /etc/apache2/sites-available/* && \
    rm -f /etc/apache2/sites-enabled/*

# copy site conf echo "ServerName localhost:80" >> /etc/apache2/apache2.conf && \
COPY conf/* /etc/apache2/sites-available/

# copy in code
COPY src/ /var/www/html/
#ADD errors/ /var/www/errors

# Add Scripts
COPY scripts/ /usr/local/bin/
RUN chmod 755 /usr/local/bin/start.sh && \
	ln -s /etc/apache2/sites-available/default.conf /etc/apache2/sites-enabled/default.conf && \
	ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf && \
	a2enmod proxy_fcgi && \
	a2enmod rewrite


EXPOSE 443 80

CMD ["/usr/local/bin/start.sh"]