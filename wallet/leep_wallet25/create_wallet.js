const bip39 = require('bip39');
const { DirectSecp256k1HdWallet } = require('@cosmjs/proto-signing');

async function generateWallets(count) {
    const wallets = [];
    for (let i = 0; i < count; i++) {
        // Генерация мнемонической фразы с помощью bip39
        const mnemonic = bip39.generateMnemonic();
        
        // Создание кошелька на основе мнемонической фразы
        const wallet = await DirectSecp256k1HdWallet.fromMnemonic(mnemonic);
        const [firstAccount] = await wallet.getAccounts();
        
        wallets.push({
            address: firstAccount.address,
            mnemonic: mnemonic
        });
    }
    return wallets;
}

async function main() {
    const wallets = await generateWallets(25);

    wallets.forEach((wallet) => {
        console.log(`${wallet.address};${wallet.mnemonic}`);
    });
}
