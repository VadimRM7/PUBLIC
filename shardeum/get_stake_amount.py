import sys
from subprocess import STDOUT, CalledProcessError, check_output


def get_secure_input(prompt):
    while True:
        try:
            user_input = input(prompt)
            if user_input.strip():
                return user_input
        except KeyboardInterrupt:
            print("EXIT.")
            print("===============")
            sys.exit(1)


def get_stake_amount(wallet_address):
    stake_info_command = [
        "docker", "exec", "-i", "shardeum-dashboard",
        "operator-cli", "stake_info", wallet_address,
    ]

    try:
        output = check_output(stake_info_command, stderr=STDOUT, universal_newlines=True)
        lines = output.split('\n')
        for line in lines:
            if line.startswith("stake:"):
                parts = line.split()
                if len(parts) > 1:
                    return parts[1].strip("'")
    except CalledProcessError:
        print("Произошла ошибка выполнения. Проверьте статус шардиума :)")
        sys.exit(1)

    return "ОШИБКА"


stake_amount = get_stake_amount(get_secure_input("Введите адресс: ")) or 0
print(f"Количество застейканых монет: {stake_amount}")
