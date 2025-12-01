const { ethers } = require('ethers');
const wallet = ethers.Wallet.createRandom();
console.log('Private key:', wallet.privateKey);
console.log('Address:', wallet.address);
