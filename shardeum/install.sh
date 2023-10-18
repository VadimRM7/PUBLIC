#!/bin/bash

apt install expect -y
. <(wget -qO- https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh) &>/dev/null
. <(wget -qO- https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh) &>/dev/null
wget -qO ./update_shard.sh https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh
chmod +x ./update_shard.sh

expect -c '
#!/usr/bin/expect

set timeout 5

spawn ./update_shard.sh

while 1 {
    interact {
        -nobuffer -o "By running this installer, you agree to allow the Shardeum team to collect this data. (Y/n)?" {send "y\r"}
        "What base directory should the node use (default ~/.shardeum):" {send "\r"}
        "Do you want to run the web based Dashboard? (Y/n):" {send "\r"}
        "Do you really want to upgrade now (y/N)?" {send "y\r"}
        "Do you want to change the password for the Dashboard? (y/N):" {send "\r"}
        "Enter the port (1025-65536) to access the web based Dashboard" {send "\r"}
        "If you wish to set an explicit external IP, enter an IPv4 address" {send "\r"}
        "If you wish to set an explicit internal IP, enter an IPv4 address" {send "\r"}
        "Enter the first port (1025-65536) for p2p communication" {send "\r"}
        "Enter the second port (1025-65536) for p2p communication" {send "\r"}
        eof {break}
    }
}'

rm ./update_shard.sh
cd $HOME
source $HOME/.shardeum/.env

echo -e "\033[1;31;40mShardeum обновлен. Проверь количество токенов в explorer-sphinx.shardeum.org и делай стейк!\033[m"
