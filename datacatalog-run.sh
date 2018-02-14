#
# start mysql

service mysql start

#
# start Solr (-force directive because everything runs as root in this Docker container)

/opt/solr-6.6.2/bin/solr start -force

#
# start apache

/usr/sbin/apachectl start

#
# Once everything is running, upload datacatalog core in solr with database contents
# by running the SolrIndexer python script

/usr/bin/python /var/www/datacatalog/SolrIndexer.py

#
# start bash so our container stays running

/bin/bash
