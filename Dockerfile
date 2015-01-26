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
RUN apt-get dist-upgrade -qy && apt-get -q update

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl curl lynx-cur

# Fix the "server's fully qualified domain name" issue
RUN echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
RUN ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini
 
# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Install I-Librarian
RUN apt-get -qy install wget xz-utils php5 php5-sqlite php5-gd ghostscript poppler-utils pdftk tesseract-ocr
WORKDIR /var/www/html/librarian
RUN wget -O i-librarian.tar.xz http://i-librarian.net/counter.php?file=127
RUN unxz i-librarian.tar.xz
RUN tar -xvf i-librarian.tar
RUN chown -R www-data:www-data library
RUN chown root:root library/.htaccess
RUN ln -s /var/www/html/librarian/library /library

# Cleanup
RUN rm i-librarian.* 

ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80
 
CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]
