#!/bin/bash

npm install bip39

mkdir leap-wallet-generator
cd leap-wallet-generator

git clone https://github.com/YAbl0K0/LeepWallet30.git
cd LeepWallet30
npm install

node createWallet.js

sleep 60

cd ../..
rm -rf leap-wallet-generator

clear
