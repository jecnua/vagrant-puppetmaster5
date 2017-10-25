#!/bin/bash

sudo su -
apt-get update
apt-get upgrade -y
apt-get install -y docker.io apt-transport-https awscli jq curl nfs-common htop


mkdir -p /home/ubuntu/puppetdb-postgres/data
chmod -R 777 /home/ubuntu/puppetdb-postgres/
cd /home/ubuntu || exit
git clone https://github.com/puppetlabs/puppet-in-docker-examples.git

docker stop puppetserver
docker rm puppetserver
docker run \
  -d \
  --name='puppetserver' \
  -p 8140:8140 \
  --add-host puppetdb:172.16.3.2 \
  -v /home/ubuntu/code:/etc/puppetlabs/code/ \
  -v /home/ubuntu/puppet/ssl:/etc/puppetlabs/puppet/ssl/ \
  -v /home/ubuntu/puppet/serverdata:/opt/puppetlabs/server/data/puppetserver/ \
  -e "PUPPETDB_SERVER_URLS=https://puppetdb:8081" \
  puppet/puppetserver

docker stop postgres
docker rm postgres
docker run --net=host \
    -d \
    --name='postgres' \
    -p 5432:5432 \
    -v /home/ubuntu/puppetdb-postgres/data:/var/lib/postgresql/data/ \
    -e "PPOSTGRES_PASSWORD=puppetdb" \
    -e "POSTGRES_USER=puppetdb" \
    puppet/puppetdb-postgres

# https://github.com/puppetlabs/puppet-in-docker/blob/master/puppetdb/conf.d/database.conf#L4
# https://docs.puppet.com/puppetdb/2.3/configure.html#subname
# //<HOST>:<PORT>/<DATABASE>
docker stop puppetdb
docker rm puppetdb
# --net=host \
docker run \
    -d \
    --name='puppetdb' \
    -h puppetdb \
    -p 8080:8080 \
    -p 8081:8081 \
    --add-host puppetdb:172.16.3.2 \
    --add-host puppet:172.16.3.2 \
    -v /home/ubuntu/puppet/puppetdb/ssl:/etc/puppetlabs/puppet/ssl/ \
    -e 'PUPPETDB_DATABASE_CONNECTION=//172.16.3.2:5432/puppetdb' \
    -e "PPOSTGRES_PASSWORD=puppetdb" \
    -e "POSTGRES_USER=puppetdb" \
    -e "HOSTNAME=puppetdb" \
    -e "no_proxy=*" \
    puppet/puppetdb:5.1.1

docker stop puppetboard
docker rm puppetboard
docker run --net=host \
    -d \
    --name='puppetboard' \
    -e 'PUPPETDB_HOST=localhost' \
    -p 8000:8000 \
    puppet/puppetboard

docker stop puppetexplorer
docker rm puppetexplorer
docker run \
    -d \
    --name='puppetexplorer' \
    --add-host puppetdb:172.16.3.2 \
    -p 80:80 \
    puppet/puppetexplorer

# docker stop puppetagent
# docker rm puppetagent
# docker run \
#   -d \
#   -h `uuidgen` \
#   --name='puppetagent' \
#   --add-host puppet:172.16.3.2 \
#   puppet/puppet-agent-ubuntu agent --verbose --no-daemonize --summarize
