module CoinoneHelper
  def get_balance
    access_token = ENV['COINONE_ACCESS_TOKEN']
    secret_key = ENV['COINONE_SECRET_KEY']

    origin = 'https://api.coinone.co.kr'
    url = origin + '/v2/account/balance'

    timestamp = DateTime.now.strftime('%Q').to_i
    json_param = {access_token: access_token, nonce: timestamp}.to_json

    # use strict_encode64 to remove new line
    payload = Base64.strict_encode64(json_param)

    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha512'), secret_key, payload)

    res = RestClient.post url, payload, {'X-COINONE-PAYLOAD': payload, 'X-COINONE-SIGNATURE': signature}
    result = JSON.parse(res.body)

    watch_coins = ['btc', 'eth', 'ltc', 'bch', 'xrp']

    result.select! {|key, val| watch_coins.include?(key) && val.is_a?(Hash) && val['balance'].to_f.positive?}
    result.transform_values! {|val| {balance: val['balance'].to_f}}

    url = origin + '/ticker'
    threads = []

    result.each do |key, val|
      threads << Thread.new do
        res = RestClient.get("#{url}?currency=#{key}")
        Thread.current[:body] = JSON.parse(res.body)
      end
    end

    sum = {krw: 0, krw_yesterday: 0}

    threads.each do |t|
      t.join
      currency = t[:body]['currency']
      balance = result[currency][:balance]
      krw = (balance * t[:body]['last'].to_f).to_i

      if krw < 10000
        result.delete currency
        next
      end

      sum[:krw] += krw
      result[currency][:krw] = krw

      krw_yesterday = (balance * t[:body]['yesterday_last'].to_f).to_i
      sum[:krw_yesterday] += krw_yesterday
      result[currency][:krw_yesterday] = krw_yesterday
      result[currency][:diff] = (krw - krw_yesterday) / krw_yesterday.to_f
      # result[currency][:ticker] = t[:body]
    end

    sum[:diff] = (sum[:krw] - sum[:krw_yesterday]) / sum[:krw_yesterday].to_f

    {result: result, sum: sum}
  end
end
