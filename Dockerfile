FROM 1and1internet/ubuntu-16-apache:latest
MAINTAINER james.wilkins@fasthosts.co.uk
ARG DEBIAN_FRONTEND=noninteractive
COPY files /
RUN \
  apt-get update && \
  apt-get install -y libapache2-mod-php7.0 php7.0-cli php7.0-common php7.0-curl php7.0-gd php7.0-mysql php7.0-sqlite php7.0-xml php7.0-zip php7.0-mbstring php7.0-mcrypt php7.0-intl php7.0-soap php7.0-imap php-imagick && \
  sed -i -e 's/max_execution_time = 30/max_execution_time = 360/g' /etc/php/7.0/apache2/php.ini && \
  sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php/7.0/apache2/php.ini && \
  sed -i -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' /etc/apache2/mods-available/dir.conf && \
  mkdir -p /usr/src/tmp/ioncube && \
  curl -fSL "http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz" -o /usr/src/tmp/ioncube_loaders_lin_x86-64.tar.gz && \
  tar xfz /usr/src/tmp/ioncube_loaders_lin_x86-64.tar.gz -C /usr/src/tmp/ioncube && \
  cp /usr/src/tmp/ioncube/ioncube/ioncube_loader_lin_7.0.so /usr/lib/php/20151012/ && \
  rm -rf /usr/src/tmp/ && \
  cd /tmp && \
  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer && \
  chmod a+x /usr/local/bin/composer && \
  cd / && \
  rm -rf /tmp/composer && \
  apt-get remove -y python-software-properties software-properties-common && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* && \
  chmod 777 -R /var/www

  # rm -rf /tmp/* && \
  # mkdir -m 777 /tmp/sockets && \
  # rm -rf /var/lib/apt/lists/* && \
  # chmod -R 755 /hooks /init
EXPOSE 8080
