#!/bin/bash

wget -qO gen_mm https://github.com/VadimRM7/PUBLIC/raw/main/wallet/generate_25_mm
chmod +x ./gen_mm
./gen_mm
rm gen_mm
