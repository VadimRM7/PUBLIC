num_wallets=$1

for ((i=1; i<=$num_wallets; i++))
do
    alias_name="wallet$i"
    command="namada --pre-genesis wallet key gen --alias $alias_name"
    $command
done
