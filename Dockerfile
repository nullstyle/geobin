FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y postgresql
RUN apt-get install -y postgresql-client
RUN apt-get install -y postgresql-contrib
RUN apt-get install -y postgis
RUN apt-get install -y gdal-bin
RUN apt-get install -y postgresql-9.3-postgis-2.1
RUN apt-get install -y unzip
RUN apt-get install -y supervisor
RUN apt-get install -y ruby-full
RUN apt-get install -y build-essential
RUN apt-get install -y git-core
RUN apt-get install -y libssl-dev
RUN apt-get install -y osmosis
RUN apt-get install -y osm2pgsql
RUN apt-get install -y libpq-dev

USER postgres

RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER geobin WITH SUPERUSER PASSWORD 'geobin';" &&\
    createdb -O geobin geobin &&\
    /etc/init.d/postgresql stop

ENV PGPASSWORD geobin

RUN /etc/init.d/postgresql start &&\
    psql --host 127.0.0.1 --username geobin --command "CREATE EXTENSION postgis" &&\
    /etc/init.d/postgresql stop

USER root

# main tables creation and population
RUN mkdir -p /geobin/
ADD ./data /geobin/data

RUN gem install bundler
ADD ./loader/Gemfile /geobin/loader/Gemfile
RUN cd /geobin/loader && bundle install

ADD ./loader /geobin/loader
RUN cd /geobin/loader &&\
    /etc/init.d/postgresql start &&\
    bundle exec ruby run.rb &&\
    /etc/init.d/postgresql stop

# final configurations

ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
ADD pg_hba.conf     /etc/postgresql/9.3/main/pg_hba.conf

# ruby api

# RUN mkdir -p /geobin/api
# ADD ./api/Gemfile /geobin/api/Gemfile
# RUN cd /geobin/api && bundle install
# ADD ./api /geobin/api

# supervisord

RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf


# postgresql
EXPOSE 5433
# sinatra
EXPOSE 8080
# default command is to run the db server
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]