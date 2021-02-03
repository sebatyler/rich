class Coinone
  extend CoinoneHelper
end

ret = Coinone.get_balance
text = ApplicationController.render template: 'coinone/index', assigns: ret, layout: false

require 'telegram_bot'

bot = TelegramBot.new(token: ENV['TELEGRAM_BOT_TOKEN'])
messages = bot.get_updates(timeout: 5)

# TODO: apply some commands and save it

if messages
  puts messages.map(&:inspect)

  message = messages.last
  channel_id = message.chat.id
else
  puts 'no messages'
  channel_id = ENV['TELEGRAM_BOT_CHANNEL_ID']
end

channel = TelegramBot::Channel.new(id: channel_id)
message = TelegramBot::OutMessage.new
message.chat = channel
message.parse_mode = 'HTML'
message.text = text
message.send_with(bot)
