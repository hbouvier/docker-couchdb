#!/bin/bash
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

set -e

if [ "$1" = '/opt/couchdb/bin/couchdb' ]; then

	if [ ! -d '/opt/couchdb/etc/default.d' ]; then
		mkdir -p /opt/couchdb/data /opt/couchdb/etc/local.d /opt/couchdb/etc/default.d
		cp -R /opt/couchdb/initial-config/etc/ /opt/couchdb/

		# cat >> /opt/couchdb/etc/local.ini <<-'LOCAL_INI'
		# 	[couchdb]
		# 	uuid = ${COUCHDB_UUID}

		# 	[admins]
		# 	admin = ${COUCHDB_ADMIN}

		# 	[couch_httpd_auth]
		# 	secret = ${COUCHDB_HTTPD_AUTH_SECRET}
		# LOCAL_INI

		# cat >> /opt/couchdb/etc/vm.args <<-'VM_ARGS'
		# 	# Each node in the system must have a unique name.  A name can be short
		# 	# (specified using -sname) or it can by fully qualified (-name).  There can be
		# 	# no communication between nodes running with the -sname flag and those running
		# 	# with the -name flag.
		# 	-name ${COUCHDB_ERLANG_SERVICE_NAME}@${CONTAINER_IP_ADDRESS}

		# 	# All nodes must share the same magic cookie for distributed Erlang to work.
		# 	# Comment out this line if you synchronized the cookies by other means (using
		# 	# the ~/.erlang.cookie file, for example).
		# 	-setcookie ${COUCHDB_ERLANG_COOKIE}
		# VM_ARGS
	fi

	# we need to set the permissions here because docker mounts volumes as root
	chown -R couchdb:couchdb /opt/couchdb

	chmod -R 0770 /opt/couchdb/data

	chmod 664 /opt/couchdb/etc/*.ini
	chmod 775 /opt/couchdb/etc/*.d

	if [ ! -z "$NODENAME" ] && ! grep "couchdb@" /opt/couchdb/etc/vm.args; then
		echo "-name couchdb@$NODENAME" >> /opt/couchdb/etc/vm.args
	fi

	if [ "$COUCHDB_USER" ] && [ "$COUCHDB_PASSWORD" ]; then
		# Create admin
		printf "[admins]\n%s = %s\n" "$COUCHDB_USER" "$COUCHDB_PASSWORD" > /opt/couchdb/etc/local.d/docker.ini
		chown couchdb:couchdb /opt/couchdb/etc/local.d/docker.ini
	fi

	# if we don't find an [admins] section followed by a non-comment, display a warning
	if ! grep -Pzoqr '\[admins\]\n[^;]\w+' /opt/couchdb/etc/local.d/*.ini; then
		# The - option suppresses leading tabs but *not* spaces. :)
		cat >&2 <<-'EOWARN'
			****************************************************
			WARNING: CouchDB is running in Admin Party mode.
							 This will allow anyone with access to the
							 CouchDB port to access your database. In
							 Docker's default configuration, this is
							 effectively any other container on the same
							 system.
							 Use "-e COUCHDB_USER=admin -e COUCHDB_PASSWORD=password"
							 to set it in "docker run".
			****************************************************
		EOWARN
	fi


	exec gosu couchdb "$@"
fi

exec "$@"
