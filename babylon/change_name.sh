#!/bin/bash


filename="/root/.babylond/config/config.toml"

if [[ ! -f "$filename" ]]; then
    echo "Файл не найден!"
    exit 1
fi

echo "Введите новое значение для name:"
read newname

sed -i "s/moniker =[^)]*/moniker =$newname/" "$filename"

echo "Замена выполнена!"
