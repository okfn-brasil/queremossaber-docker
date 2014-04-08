# QueremosSaber.org.br
#
# VERSION 0.1

FROM ubuntu
MAINTAINER Vitor Baptista <vitor@vitorbaptista.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl sudo rsyslog supervisor cron

# Install Alaveteli configured for queremossaber.org.br
RUN curl -O https://raw.github.com/mysociety/commonlib/master/bin/install-site.sh
RUN sh install-site.sh --default alaveteli alaveteli queremossaber.org.br

# Run alaveteli in foreground
RUN sed -i "s/bundle exec thin -d/bundle exec thin/g" /etc/init.d/alaveteli

# Run alaveteli in production environment
RUN sed -i "s/-e development start/-e production start/g" /etc/init.d/alaveteli

# Run nginx in foreground
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Put data into /data directory
ENV PGDATA /data/postgresql/main
RUN sed -i "s|/var/lib/postgresql/9.1/main|$PGDATA|g" /etc/postgresql/9.1/main/postgresql.conf
RUN sed -i "s|/etc/postgresql/9.1/main|$PGDATA|g" /etc/postgresql/9.1/main/postgresql.conf

EXPOSE 80
EXPOSE 25

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.alaveteli.conf
ADD start-alaveteli.sh /usr/local/bin/start-alaveteli.sh

RUN chmod +x /usr/local/bin/start-alaveteli.sh

CMD ["/usr/local/bin/start-alaveteli.sh"]
