class Coinone
  extend CoinoneHelper
end

ret = Coinone.get_balance

CoinoneMailer.with(
  recipient: ENV['MAIL_USER'] + '@gmail.com',
  result: ret[:result],
  sum: ret[:sum]
).balance.deliver_now