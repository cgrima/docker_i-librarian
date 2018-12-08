# I, Librarian Server
FROM debian:stretch
LABEL maintainer="tux1337"

# Environment variables
ENV ILIB_VERSION 4.10
ENV UID 33
ENV GID 33

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN apt-get update && apt-get install -y --force-yes\
    apache2\
    curl\
    ghostscript\
    libreoffice\
    poppler-utils\
    php7.0\
    php7.0-curl\
    php7.0-gd\
    php7.0-ldap\
    php7.0-sqlite\
    php7.0-xml\
    php7.0-zip\
    sqlite3\
    tesseract-ocr\
    xz-utils\
 && apt-get clean

# Update php.ini
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini\
 && sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini\
 && sed -i "s/\; max_input_vars = 1000/max_input_vars = 10000/" /etc/php/7.0/apache2/php.ini

# Install I-Librarian
RUN mkdir -p /var/www/html/librarian \
 && curl https://i-librarian.net/downloads/I,-Librarian-${ILIB_VERSION}-Linux.tar.xz \
    --output i-librarian.tar.xz \
 && tar -xvf i-librarian.tar.xz -C /var/www/html/librarian \
 && rm i-librarian.tar.xz \
 && ln -s /var/www/html/librarian/library /library

# Set up Apache
RUN usermod -u ${UID} www-data\
 && groupmod -g ${GID} www-data\
 && chown -R www-data:www-data /var/www/html/librarian/library\
 && chown root:root /var/www/html/librarian/library/.htaccess

ADD librarian.conf /etc/apache2/sites-available/librarian.conf

RUN a2enmod rewrite headers \
 && a2dissite 000-default \
 && a2ensite librarian

WORKDIR /var/www/html

EXPOSE 80

CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]
