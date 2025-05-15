#!/bin/bash

set -e

# Step 1.1: Start keosd
keosd --unlock-timeout=9999999 &

# Step 1.2: Start nodeos
# More options: https://developers.eos.io/manuals/eos/v2.0/nodeos/plugins/http_plugin/index
nodeos -e -p eosio \
--plugin eosio::producer_plugin \
--plugin eosio::producer_api_plugin \
--plugin eosio::chain_api_plugin \
--plugin eosio::http_plugin \
--plugin eosio::history_plugin \
--plugin eosio::history_api_plugin \
--filter-on="*" \
--http-server-address=0.0.0.0:8888 \
--access-control-allow-headers=content-type \
--access-control-allow-origin='*' \
--contracts-console \
--http-validate-host=false \
--logconf=/logging.json \
--verbose-http-errors >> /tmp/nodeos.log 2>&1 &

sleep 1

cleos wallet create --to-console

sleep 1

# eosio default private key
cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

sleep 1

export HOME=/app

if [[ -f $PWD/docker/entrypoint.sh ]]; then
    echo "entry point found! $PWD/docker/entrypoint.sh"
    echo "--------------------------------------------"
    $PWD/docker/entrypoint.sh
fi


# echo "**********"
# cat /etc/profile.d/aliases.sh
# source /etc/profile.d/aliases.sh
# echo "**********"

echo "----------"
echo "alias ll='ls -las'"
echo "alias telosmain='cleos --url https://telos.caleos.io '"
echo "alias telostest='cleos --url https://testnet.telos.caleos.io '"
echo "----------"
echo "tail -f /tmp/nodeos.log"
echo "cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
echo "telosmain system newaccount --stake-net '0.5000 TLOS' --stake-cpu '0.5000 TLOS' --buy-ram-kbytes 3 viterbotelos cryptokibutz EOS5SicH9s2UGrDFJuM23CpiC9FmpbrBvXrFEYkutucAJnVZmHPj7 EOS8MPwGHuGSHSfBp3HAWsrHDotAqp9ZPShBvNcGDpcmNNa5h8y1Q -p viterbotelos@active"
echo "wget -q -O - ""$@"" http://localhost:8888/v1/chain/get_info | jq"
echo "----------"
bash


