# CouchDB

To build the container run

```bash
docker build --rm -t hbouvier/couchdb .
```

To run it

```bash
docker run -d -e COUCHDB_BIND_ADDRESS=0.0.0.0 -p 5984:5984 hbouvier/couchdb
```

To test it:

```bash
curl http://localhost:5984
```
