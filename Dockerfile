FROM alpine:3.17
MAINTAINER ratler@undernet.org

ENV PYTHONUNBUFFERED 1

RUN apk --no-cache update && apk --no-cache upgrade && \
    apk --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.17/community add \
    bash \
    busybox-extras \
    apache2 \
    php-apache2 \
    curl \
    ca-certificates \
    openssl \
    openssh \
    git \
    php \
    python3 \
    tzdata

RUN apk --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.17/community add \
    php-phar \
    php-json \
    php-iconv \
    php-openssl \
    php81-pecl-xdebug \
    php-mbstring \
    php-soap \
    php-gmp \
    php-pdo_odbc \
    php-dom \
    php-pdo \
    php-zip \
    php-sqlite3 \
    php-pgsql \
    php-pdo_pgsql \
    php-bcmath \
    php-gd \
    php-odbc \
    php-gettext \
    php-xml \
    php-xmlreader \
    php-xmlwriter \
    php-tokenizer \
    php-bz2 \
    php-pdo_dblib \
    php-curl \
    php-ctype \
    php-session \
    php-exif \
    php-intl \
    php-fileinfo \
    php81-pecl-apcu \
    php-simplexml \
    composer

# Setup apache
RUN for m in rewrite_module session_module session_cookie_module ession_crypto_module deflate_module; do \
    sed -i "/^#LoadModule $m/s;#;;" /etc/apache2/httpd.conf; done
RUN sed -i "s;^#DocumentRoot.*;DocumentRoot /app/docs/gnuworld;" /etc/apache2/httpd.conf && \
    sed -i "s;/var/www/localhost/htdocs;/app/docs/gnuworld;" /etc/apache2/httpd.conf && \
    printf "\n<Directory /app>\n\tRequire all granted\n</Directory>\n" >> /etc/apache2/httpd.conf

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /app
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 5000

CMD ["httpd", "-D", "FOREGROUND"]
