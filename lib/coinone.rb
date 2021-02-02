class Coinone
  extend CoinoneHelper
end

require 'telegram_bot'

bot = TelegramBot.new(token: ENV['TELEGRAM_BOT_TOKEN'])
messages = bot.get_updates

puts messages.map(&:inspect)
# TODO: apply some commands

message = messages.last


ret = Coinone.get_balance
text = ApplicationController.render template: 'coinone/index', assigns: ret, layout: false

message.reply do |reply|
  reply.text = text
  reply.parse_mode = 'HTML'
  reply.send_with(bot)
end