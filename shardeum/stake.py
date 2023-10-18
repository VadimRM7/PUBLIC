import os
import sys
from random import randint, uniform
from subprocess import CalledProcessError, check_output, Popen, DEVNULL
from time import sleep


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


def start_node():
    start_node_command = [
        "docker", "exec", "-i", "shardeum-dashboard",
        "operator-cli", "start"
    ]

    return Popen(start_node_command, stdout=DEVNULL, stderr=DEVNULL)


def get_stake_amount(wallet_address):
    stake_info_command = [
        "docker", "exec", "-i", "shardeum-dashboard",
        "operator-cli", "stake_info", wallet_address,
    ]

    try:
        output = check_output(stake_info_command, stderr=DEVNULL, universal_newlines=True)
        lines = output.split('\n')
        for line in lines:
            if line.startswith("stake:"):
                parts = line.split()
                if len(parts) > 1:
                    return parts[1].strip("'")
    except CalledProcessError:
        sys.exit(1)

    return None


def run_stake_command(private_key, stake_value):
    stake_command = [
        "docker", "exec", "-i", "shardeum-dashboard", "sh", "-c",
        "(sleep 10; echo '{0}'; sleep 10) | operator-cli stake {1}".format(private_key, stake_value),
    ]

    return Popen(stake_command, stdout=DEVNULL, stderr=DEVNULL)


def attempt_stake(private_key, wallet_address, num_retries, init_stake_amount):
    for i in range(num_retries):
        try:
            stake_amount = get_stake_amount(wallet_address)  # get current stake amount
            stake_value = round(uniform(10, 12), 1)  # generate random amount to stake

            if stake_amount != init_stake_amount:
                print(f"\033[1;31;40mГОТОВО! Было стейкнуто: {stake_value}\033[m")
                return True

            print(f"ПОПЫТКА СТЕЙКА #{i}")
            stake_process = run_stake_command(private_key, stake_value)
            sleep(randint(40, 90))

            if stake_process.poll() is None:
                stake_process.terminate()
        except CalledProcessError as e:
            print("Произошла ошибка. Обращаться к Владу")

    return False


def main():
    if os.path.exists("credentials.txt"):
        os.remove("credentials.txt")

    start_node()
    private_key = get_secure_input("Приватный ключ: ")
    wallet_address = get_secure_input("Адрес: ")
    init_stake_amount = get_stake_amount(wallet_address)
    is_staked = (
            attempt_stake(private_key, wallet_address, 3, init_stake_amount) or
            sleep(randint(1000, 2000)) or
            attempt_stake(private_key, wallet_address, randint(5, 6), init_stake_amount)
    )

    if not is_staked:
        print(f"\033[1;31;40mНЕ ПОЛУЧИЛОСЬ ЗАСТЕЙКАТЬ. ЗАПУСКАЙТЕ КОММАНДУ ЕЩЕ РАЗ\033[m")


if __name__ == "__main__":
    main()
