#!/bin/bash --login

echo "### Update system"
sudo yum update

echo "### Installing package dependencies"
sudo yum install -y apr-devel apr-util-devel autoconf automake curl-devel \
                    g++ gcc gcc-c++ git glibc-headers httpd-devel libxml2 \
                    libxml2-devl libxslt libxslt-devel libyaml-devel make \
                    openssl-devel patch readline \
                    readline-devel zlib zlib-devel

echo "### Installing Postgresql"
sudo yum install -y https://yum.postgresql.org/9.6/redhat/rhel-7.3-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
sudo yum install -y postgres96 postgresql96-server postgresql96-contrib postgresql96-devel libpq-devel
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb

echo "### Updating postgresql connection info"
sudo cp /var/lib/pgsql/9.6/data/pg_hba.conf .
sudo chmod 666 pg_hba.conf
sed 's/ident/md5/' < pg_hba.conf > pg_hba2.conf
echo 'host    all             all             0.0.0.0/0               md5' >> pg_hba2.conf
sudo cp pg_hba2.conf /var/lib/pgsql/9.6/data/pg_hba.conf
sudo chmod 600 /var/lib/pgsql/9.6/data/pg_hba.conf

sudo cp /var/lib/pgsql/9.6/data/postgresql.conf .
sudo chmod 666 postgresql.conf
sed "s/^#listen_addresses.*$/listen_addresses = '0.0.0.0'/" < postgresql.conf > postgresql2.conf
sudo cp postgresql2.conf /var/lib/pgsql/9.6/data/postgresql.conf
sudo chmod 600 /var/lib/pgsql/9.6/data/postgresql.conf
sudo /sbin/service postgresql-9.6 restart

DATABASE_YML="/vagrant/config/database.yml"
APP_DB_USERNAME="vagrant"
APP_DB_PASSWORD="123"

CREATE_USER_SQL="CREATE ROLE $APP_DB_USERNAME PASSWORD '$APP_DB_PASSWORD' CREATEDB INHERIT LOGIN;"
sudo -u postgres psql --command="$CREATE_USER_SQL"
ALTER_USER_SQL="ALTER USER $APP_DB_USERNAME WITH ENCRYPTED PASSWORD '$APP_DB_PASSWORD'"
sudo -u postgres psql --command="$ALTER_USER_SQL"
ALTER_POSTGRES_USER_SQL="ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres'"
sudo -u postgres psql --command="$ALTER_POSTGRES_USER_SQL"

cat > $DATABASE_YML <<_EOF_
  default: &default
    adapter: postgresql
    encoding: utf8
    min_messages: warning
    pool: 5
    timeout: 5000
    username: $APP_DB_USERNAME
    password: $APP_DB_PASSWORD
    host: localhost
  development:
    <<: *default
    database: flashcards_development
  test:
    <<: *default
    database: flashcards_test
  production:
    <<: *default
    database: flashcards_production
_EOF_

echo "cd /vagrant" >> /home/vagrant/.bashrc

echo "### Installing git"
sudo yum install -y git

echo "### Installing Node.js"
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
sudo yum install -y nodejs

echo "### Installing RVM and Ruby"

curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://get.rvm.io | sudo -u vagrant bash -s stable
echo "source /home/vagrant/.rvm/scripts/rvm " >> /home/vagrant/.bash_profile 

echo "source /home/vagrant/.profile" >> /home/vagrant/.bash_profile
source /home/vagrant/.profile
rvm requirements
rvm install 2.4.0

shift

gem install bundler
gem install pg -v '0.19.0' -- --with-pg-config=/usr/pgsql-9.6/bin/pg_config

cd /vagrant
sudo su - vagrant -c "bundle install"

echo "### Create database and migrating"
sudo su - vagrant -c "rails db:create"
sudo su - vagrant -c "rails db:migrate"
