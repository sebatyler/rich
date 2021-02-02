class Coinone
  extend CoinoneHelper
end

require 'telegram_bot'

bot = TelegramBot.new(token: ENV['TELEGRAM_BOT_TOKEN'])
message = bot.get_updates.last

ret = Coinone.get_balance
text = ApplicationController.render template: 'coinone/index', assigns: ret, layout: false

message.reply do |reply|
  reply.text = text
  reply.parse_mode = 'HTML'
  reply.send_with(bot)
end