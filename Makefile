help:
	@echo 'BUILD THE CONTAINER'
	@echo '    make build'
	@echo ''
	@echo 'PUBLISH THE CONTAINER'
	@echo '    make publish'
	@echo ''
	@echo 'BUILD & PUBLISH THE CONTAINER'
	@echo '    make all'
	@echo ''
	@echo 'TO RUN THE CONTAINER'
	@echo '    make run'
	@echo ''
	@echo 'TO OPEN THE fauxton WEB UI'
	@echo '    make fauxton'
	@echo ''
	@echo 'RUN COUCHDB WITH external configuration files'
	@echo '    docker run --name couchdb -p 5984:5984 -v /var/lib/couchdb/data:/opt/couchdb/data -v /var/lib/couchdb/etc:/opt/couchdb/etc -td hbouvier/couchdb:2.0.0-0001'
	@echo '    open http://192.168.99.100:5984/_utils'

all: build publish

build:
	docker build -f Dockerfile -t hbouvier/couchdb:2.0.0-CORS-0001 .

publish:
	docker push hbouvier/couchdb:2.0.0-CORS-0001

run:
	docker run --name couchdb -p 5984:5984 -v /var/lib/couchdb/data:/opt/couchdb/data -td hbouvier/couchdb:2.0.0-0001

fauxton:
	open http://192.168.99.100:5984/_utils