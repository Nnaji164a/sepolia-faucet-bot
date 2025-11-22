require('dotenv').config();
const { ethers } = require('ethers');

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const wallet = new ethers.Wallet(PRIVATE_KEY);
console.log('Bot wallet address:', wallet.address);