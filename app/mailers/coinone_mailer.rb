class CoinoneMailer < ApplicationMailer
  default from: ENV['MAIL_USER'] + '@gmail.com'

  # to use show_number in balance.html.erb
  helper :application

  # to use number_to_percentage
  include ActionView::Helpers::NumberHelper

  def balance
    @result = params[:result]
    @sum = params[:sum]

    diff = number_to_percentage @sum[:diff] * 100, precision: 1
    mail(to: params[:recipient], subject: "Coinone balance: #{diff}")
  end
end
