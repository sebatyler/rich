require 'rest-client'
require 'date'
require 'openssl'
require 'Base64'

class CoinoneController < ApplicationController
  def index
    ret = helpers.get_balance
    puts ret

    @sum = ret[:sum]
    @result = ret[:result]
  end
end
