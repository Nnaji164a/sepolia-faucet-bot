require('dotenv').config();
const { Telegraf } = require('telegraf');

console.log('Checking bot configuration...');
console.log('BOT_TOKEN exists:', !!process.env.BOT_TOKEN);
console.log('BOT_TOKEN length:', process.env.BOT_TOKEN?.length);

const bot = new Telegraf(process.env.BOT_TOKEN);

bot.telegram.getMe()
    .then(botInfo => {
        console.log('Bot info:', botInfo);
        process.exit(0);
    })
    .catch(error => {
        console.error('Bot error:', error);
        process.exit(1);
    });