#
# Install APCU_BC APCu Backwards Compatibility Module
# https://pecl.php.net/package/apcu_bc

printf "\n" | pecl install apcu_bc-beta
cat /apcu.php.ini >> /etc/php/7.0/apache2/php.ini

#
# Enable Apache Rewrite module

ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

#
# Download and extract latest datacatalog from github
# https://github.com/nyuhsl/data-catalog

git clone https://github.com/nyuhsl/data-catalog.git /var/www/datacatalog

#
# Start mysql server, create datacatalog database, extract and import sample database 

service mysql start
tar -zxf /var/www/datacatalog/starterDatabase.sql.tar.gz -C /var/www/datacatalog/
mysql --user=root --password=root -e "CREATE DATABASE datacatalog;"
mysql --user=root --password=root datacatalog < /var/www/datacatalog/data.sql
service mysql stop

#
# Copy customized parameters config files and SolrIndexer script

mv /security.yml /var/www/datacatalog/app/config/common
cp /parameters.yml /var/www/datacatalog/app/config/dev
cp /parameters.yml /var/www/datacatalog/app/config/prod
cp /SolrIndexer.py /var/www/datacatalog/

#
# install datacatalog via composer

cd /var/www/datacatalog
composer install

#
# Download and install openjdk v8 from debian jessie backports

echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
apt-get update
apt-get install -y -t jessie-backports openjdk-8-jre-headless ca-certificates-java

#
# Download and install Solr 6.2.2

wget http://www-us.apache.org/dist/lucene/solr/6.6.2/solr-6.6.2.tgz
tar -xzf solr-6.6.2.tgz -C /opt/

#
# Create and configure datacatalog core in Solr

/opt/solr-6.6.2/bin/solr start -force
/opt/solr-6.6.2/bin/solr create -force -c datacatalog
cp /solrconfig.xml /opt/solr-6.6.2/server/solr/datacatalog/conf
cp /var/www/datacatalog/SolrV6SchemaExample.xml /opt/solr-6.6.2/server/solr/datacatalog/conf/schema.xml

