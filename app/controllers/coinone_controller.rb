require 'rest-client'
require 'date'
require 'openssl'
require 'Base64'

class CoinoneController < ApplicationController
  def index
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

    result.select! {|key, val| val.is_a?(Hash) && val['balance'].to_f.positive?}
    result.transform_values! {|val| val['balance'].to_f }

    puts result
  end
end
