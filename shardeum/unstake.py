import os
import sys
from random import randint
from subprocess import STDOUT, CalledProcessError, check_output, Popen
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
        sys.exit(1)

    return None


def run_unstake_command(private_key, force=False):
    unstake_command = [
        "docker", "exec", "-i", "shardeum-dashboard", "sh", "-c",
        "(sleep 5; echo '{0}'; sleep 5) | operator-cli unstake {1}".format(private_key, "-f" if force else ""),
    ]

    return Popen(unstake_command)


def attempt_unstake(private_key, wallet_address, num_retries, force=False):
    for _ in range(num_retries):
        try:
            stake_amount = get_stake_amount(wallet_address)

            if stake_amount == "0.0":
                print("\033[1;31;40mГОТОВО!\033[m")
                return True

            unstake_process = run_unstake_command(private_key, force)
            sleep(randint(60, 180))

            if unstake_process.poll() is None:
                unstake_process.terminate()
                print("Kill unstake process, it's taking too long!")
        except CalledProcessError as e:
            print(f"Error running unstake command: {e}")

    return False


def main():
    if os.path.exists("credentials.txt"):
        os.remove("credentials.txt")

    private_key = get_secure_input("Приватный ключ: ")
    wallet_address = get_secure_input("Адрес: ")
    is_unstaked = (
            attempt_unstake(private_key, wallet_address, 3) or
            sleep(randint(1000, 2000)) or
            attempt_unstake(private_key, wallet_address, randint(2, 3)) or
            attempt_unstake(private_key, wallet_address, 3, True)
    )

    if is_unstaked:
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
