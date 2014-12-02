FROM hbouvier/trusty

ENV COUCHDB_BIND_ADDRESS 127.0.0.1

RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:couchdb/stable -y
RUN apt-get update -y
RUN apt-get remove couchdb couchdb-bin couchdb-common -yf
RUN apt-get install -y -V couchdb

RUN mkdir -p /var/run/couchdb /var/log/couchdb

VOLUME /var/lib/couchdb
VOLUME /var/log/couchdb

EXPOSE 5984
CMD sed -i -e 's/;bind_address = 127.0.0.1/bind_address = '${COUCHDB_BIND_ADDRESS}'/g' /etc/couchdb/local.ini && /usr/bin/couchdb
