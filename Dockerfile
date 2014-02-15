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

# Run nginx in foreground
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.alaveteli.conf

CMD ["/usr/bin/supervisord"]
