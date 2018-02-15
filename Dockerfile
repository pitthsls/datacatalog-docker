# Set the base image
FROM openevents/debian-jessie-lamp-php7
# Dockerfile author / maintainer 
MAINTAINER Name <jpm159@pitt.edu> 

RUN apt-get update && apt-get install -y git zip unzip lsof
RUN apt-get remove -y php7.0-snmp

EXPOSE 80
EXPOSE 8983

COPY ./datacatalog-setup.sh /
COPY ./datacatalog-run.sh /
COPY ./security.yml /
COPY ./parameters.yml /
COPY ./apcu.php.ini /
COPY ./solrconfig.xml /
COPY ./SolrIndexer.py /

#
# Apache configuration for Symfony

COPY ./000-default.conf /etc/apache2/sites-available

RUN chmod 755 /datacatalog-setup.sh
RUN chmod 755 /datacatalog-run.sh

RUN /datacatalog-setup.sh

CMD /datacatalog-run.sh