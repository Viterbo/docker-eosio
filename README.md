ln -s ~/dev/docker-eosio/run.sh /usr/bin/eosio_run

# Clear all stopped containers, unused images, networks, build cache, and volumes
docker system prune -a -f --volumes
