require 'rest-client'
require 'date'
require 'openssl'
require 'Base64'

class CoinoneController < ApplicationController
  def index
    puts helpers.get_balance
  end
end
