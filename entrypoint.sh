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

if [[ -f $PWD/autorun/entrypoint.sh ]]; then
    echo "entry point found! $PWD/autorun/entrypoint.sh"
    echo "--------------------------------------------"
    $PWD/autorun/entrypoint.sh
fi

echo "---- copy & paste on terminal ------"
echo "export HOME=/app"
echo "alias ll='ls -las'"
echo "alias telostest='cleos --url https://telostestnet.greymass.com '"
echo "alias telosmain='cleos --url https://telos.caleos.io '"
echo "alias cleos_get_table='cleos get table'"
echo "alias cleos_set_contract='cleos set contract'"
echo "alias cleos_push_action='cleos push action'"
echo "alias cleos_system_regproducer='cleos system regproducer'"
echo "./docker/scripts/_compile.sh"
echo "./docker/scripts/_test.sh"
echo "./docker/scripts/_basictoken_apply.sh"
echo "----------"
echo "tail -f /tmp/nodeos.log"
echo "cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
echo $"telosmain push action eosio.token transfer '[\"viterbotelos\", \"user11111111\", \"1.0000 TLOS\", \"\"]' -p viterbotelos@active"
echo "telosmain system newaccount --stake-net '0.5000 TLOS' --stake-cpu '0.5000 TLOS' --buy-ram-kbytes 3 viterbotelos cryptokibutz EOS5SicH9s2UGrDFJuM23CpiC9FmpbrBvXrFEYkutucAJnVZmHPj7 EOS8MPwGHuGSHSfBp3HAWsrHDotAqp9ZPShBvNcGDpcmNNa5h8y1Q -p viterbotelos@active"
echo "wget -q -O - ""$@"" http://localhost:8888/v1/chain/get_info | jq"
echo "----------"
bash


