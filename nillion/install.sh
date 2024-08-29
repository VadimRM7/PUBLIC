#!/bin/bash

sudo apt-get update
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh | bash &>/dev/null
sudo apt-get install --only-upgrade -y docker-ce docker-ce-cli containerd.io

sudo systemctl restart docker
docker --version

# Закидываем докер ниллион
if docker pull nillion/retailtoken-accuser:v1.0.0; then
  echo "Образ успешно загружен"
else
  echo "Ошибка загрузки образа" >&2
  exit 1
fi

mkdir -p nillion/accuser
sleep 30
docker run -v ./nillion/accuser:/var/tmp nillion/retailtoken-accuser:v1.0.0 initialise

echo "Установка завершена!"

tmux kill-session -t nillion_run
tmux new-session -d -s nillion_run "
    sleep $(( RANDOM % 3601 + 7200 )) &&
    docker run -d --name nillion_run_docker -v \$HOME/nillion/accuser:/var/tmp nillion/retailtoken-accuser:v1.0.0 accuse --rpc-endpoint 'https://testnet-nillion-rpc.lavenderfive.com' --block-start 5112621;
    tmux kill-session -t nillion_run
"
