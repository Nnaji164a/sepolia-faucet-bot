require('dotenv').config();
const { Telegraf } = require('telegraf');

const bot = new Telegraf(process.env.BOT_TOKEN);

bot.start((ctx) => ctx.reply(
  `Welcome to the Sepolia Faucet Bot! 🚰\n\n` +
  `Claim up to 0.2 Sepolia ETH every 24 hours to test your Ethereum projects on the Sepolia testnet.\n\n` +
  `Simply enter your wallet address and follow the prompts to get your free testnet tokens.\n\n` +
  `Start building and experimenting now! 💻`
));

bot.on('text', (ctx) => {
  ctx.reply('Thank you for your message! Bot functionality is being updated.');
});

console.log('Starting bot...');
bot.launch()
  .then(() => console.log('Bot is running!'))
  .catch(error => {
    console.error('Failed to start bot:', error);
    process.exit(1);
  });