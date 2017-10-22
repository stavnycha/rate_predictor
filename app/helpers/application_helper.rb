module ApplicationHelper

  def amount_with_currency(amount, currency)
    number_to_currency(amount, unit: currency.code, format: '%n %u')
  end
end
