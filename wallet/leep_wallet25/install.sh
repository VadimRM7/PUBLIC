#!/bin/bash

npm install bip39

mkdir leap-wallet-generator
cd leap-wallet-generator

git clone https://github.com/VadimRM7/PUBLIC/wallet/leep_wallet25.git
cd leep_wallet25
npm install

node createWallet.js

sleep 60

cd ../..
rm -rf leap-wallet-generator

clear
