module ApplicationHelper
  def show_number(key, val)
    key = key.to_s

    if key.include? 'krw'
      number_to_currency val, unit: 'KRW', precision: 0, format: '%n %u'
    elsif key.include? 'diff'
      number_to_percentage val * 100, precision: 1, format: '%n %'
    else
      number_to_currency val, unit: ''
    end
  end
end