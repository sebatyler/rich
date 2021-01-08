require 'rest-client'
require 'date'

class BitpandaController < ApplicationController
  def index
    api_key = ENV['BITPANDA_API_KEY']
    # TODO: get all pages.
    res = RestClient.get "https://api.bitpanda.com/v1/fiatwallets/transactions?type=buy&page_size=200", {"X-API-KEY": api_key}
    # res = RestClient.get "https://api.bitpanda.com/v1/fiatwallets/transactions?type=buy&page_size=20", {"X-API-KEY": api_key}

    @transactions = JSON.parse(res.body)['data'].reverse

    @amount_history = Hash.new 0

    @transactions.each do |transaction|
      date = DateTime.strptime(transaction['attributes']['time']['unix'], '%s').new_offset('+0900').to_date
      transaction['date'] = date

      amount = transaction['attributes']['amount'].to_f
      transaction['amount'] = amount
      transaction['fee'] = transaction['attributes']['fee'].to_f

      @amount_history[date.to_s] += amount
    end

    @sum_history = {}
    sum = 0

    @amount_history.each do |key, val|
      sum += val
      @sum_history[key] = sum
    end
  end
end
