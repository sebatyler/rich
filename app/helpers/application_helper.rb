module ApplicationHelper
  def show_number(val, key = :balance, unit = nil)
    key = key.to_s

    if key.include? 'krw'
      number_to_currency val, unit: unit || 'KRW', precision: 0, format: '%n %u'
    elsif key.include? 'diff'
      number_to_percentage val * 100, precision: 1, format: '%n %'
    else
      number_to_currency val, unit: unit || ''
    end
  end
end