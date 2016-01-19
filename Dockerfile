# I, Librarian Server
FROM ubuntu:14.04
MAINTAINER Cyril Grima <cyril.grima@gmail.com>

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Set locale to UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales

# Update Ubuntu
RUN apt-mark hold initscripts udev plymouth mountall
RUN apt-get -q update
RUN apt-get upgrade -qy && apt-get -q clean

# Install Dependencies. curl and lynx-cur are for debugging the container.
RUN apt-get -y install \
    apache2 \
    curl \
    ghostscript \
    libapache2-mod-php5 \
    libreoffice \
    lynx-cur \
    php-apc \
    php-pear\
    php5 \
    php5-curl \
    php5-ldap \
    php5-mysql \
    php5-sqlite \
    php5-gd \
    poppler-utils \
    tesseract-ocr \
    wget \
    xz-utils \
    && apt-get clean

# Fix the "server's fully qualified domain name" issue
RUN echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf;\
    ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf

# Enable apache mods.
RUN a2enmod php5;\
    a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini;\
    sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini;\
    sed -i "s/\; max_input_vars = 1000/max_input_vars = 10000/" /etc/php5/apache2/php.ini
 
# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Install I-Librarian
WORKDIR /var/www/html/librarian
RUN wget -O i-librarian.tar.xz http://i-librarian.net/downloads/I,-Librarian-4.0-Linux.tar.xz;\
    unxz i-librarian.tar.xz;\
    tar -xvf i-librarian.tar

# Rights and links
RUN chown -R www-data:www-data library;\
    chown root:root library/.htaccess;\
    ln -s /var/www/html/librarian/library /library

# Cleanup
RUN rm i-librarian.*

ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80
 
CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]
