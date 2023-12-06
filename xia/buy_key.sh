#!/usr/bin/expect

# Загрузка переменных окружения из файла .env
set env_file [open ".env" r]
while {[gets $env_file line] >= 0} {
    if {[regexp {^\s*([^#]+?)\s*=\s*(.+)\s*$} $line -> key value]} {
        set ::env($key) $value
    }
}

# Запуск sentry-node-cli-linux с загруженными переменными окружения
spawn ./sentry-node-cli-linux

# Ожидание загрузки оболочки
expect "Type \"help\" to display a list of actions."

# Цикл для выполнения процесса 2 раза
for {set i 0} {$i < 2} {incr i} {
    # Выполнение команды внутри оболочки
    send "mint-node-licenses\r"

    # Ответ на вопросы, используя переменные окружения
    expect "Enter the amount of tokens to mint:"
    send "$::env(TOKENS_AMOUNT)\r"

    expect "Enter the private key of the wallet:"
    send "$::env(PRIVATE_KEY)\r"

    expect "Enter the promo code (optional):"
    # Проверка наличия переменной PROMO_CODE
    if {[info exists ::env(PROMO_CODE)]} {
        send "$::env(PROMO_CODE)\r"
    } else {
        send "\r"
    }

    # Ожидание сообщения об успешной операции
    expect "Tokens successfully minted. Here are the details:"
}

# Завершение работы скрипта
expect eof
