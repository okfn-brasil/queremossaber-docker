#!/bin/bash

USER=alaveteli
VOLUME=/data
VOLUME_DB=$VOLUME/postgresql
VOLUME_WWW=$VOLUME/www
SOURCE_DIR=/var/www/alaveteli/alaveteli

# Set-up /data permissions
chmod 755 $VOLUME

# Configure postgresql to use /data
if [ ! -d $VOLUME_DB ]
then
  mkdir -p $VOLUME_DB
  chmod 700 $VOLUME_DB
  chown postgres:postgres $VOLUME_DB

  su postgres --command "/usr/lib/postgresql/9.1/bin/initdb --locale=C -D $VOLUME_DB/main"
  su postgres --command "cp /etc/postgresql/9.1/main/postgresql.conf /etc/postgresql/9.1/main/pg_hba.conf $VOLUME_DB/main"
  service postgresql start
  su postgres --command "createuser --createdb --no-createrole --no-superuser $USER"
  service postgresql stop
fi

if [ ! -d $VOLUME_WWW ]
then
  mkdir -p $VOLUME_WWW
  chown -R $USER:$USER $VOLUME_WWW
fi

# Remove directories that should be links. They'll be linked afterwards.
ln -sf $VOLUME_WWW/config/general.yml $SOURCE_DIR/config/general.yml
rm -f $SOURCE_DIR/config/database.yml
rm -f $SOURCE_DIR/config/newrelic.yml
rm -f $SOURCE_DIR/public/foi-live-creation.png
rm -f $SOURCE_DIR/public/foi-user-use.png
rm -rf $SOURCE_DIR/files
rm -rf $SOURCE_DIR/cache
rm -rf $SOURCE_DIR/lib/acts_as_xapian/xapiandbs/

service postgresql start
RAILS_ENV=production su $USER --command "cd $SOURCE_DIR && ./script/rails-post-deploy && ./script/rebuild-xapian-index"
service postgresql stop

# Run Supervisord
/usr/bin/supervisord
