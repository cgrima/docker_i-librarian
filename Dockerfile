FROM php:7.4-apache

# Variables
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV ILIB_VERSION 5.6.0
ENV UID 33
ENV GID 33

EXPOSE 80
WORKDIR /app

# Fix openjdk-11-jre configuration for Libreoffice installation
RUN mkdir -p /usr/share/man/man1

# Install Dependencies
RUN apt-get update -qq && \
    apt-get install -qy \
    ghostscript \
    git \
    gnupg \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libicu-dev \
    libldap2-dev \
    libpng-dev libxpm-dev \
    libreoffice \
    libwebp-dev \
    libzip-dev \
    poppler-utils \
    tesseract-ocr \
    unzip \
    wget \
    zip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-install \
    gd \    
    intl \
    ldap \
    sysvsem \
    sysvshm \
    zip
    
# PHP Extensions
RUN docker-php-ext-install -j$(nproc) opcache pdo_mysql
COPY conf/php.ini /usr/local/etc/php/conf.d/app.ini

# Install I-Librarian
RUN wget https://github.com/mkucej/i-librarian-free/archive/${ILIB_VERSION}.tar.gz \
 && tar -xvf ${ILIB_VERSION}.tar.gz --strip-components 1 -C /app \
 && rm ${ILIB_VERSION}.tar.gz
RUN chown -R www-data:www-data /app/data

# Apache
COPY conf/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY conf/apache.conf /etc/apache2/conf-available/z-app.conf

RUN a2enmod rewrite remoteip && \
    a2enconf z-app

CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]
