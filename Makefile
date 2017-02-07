
all:
	docker build -f Dockerfile -t hbouvier/couchdb:2.0.0-0001 .

help:
	@echo 'docker run --name couchdb -p 5984:5984 -v /var/lib/couchdb/data:/opt/couchdb/data -v /var/lib/couchdb/etc:/opt/couchdb/etc -td hbouvier/couchdb:2.0.0-0001'
	@echo 'open http://192.168.99.100:5984/_utils'
