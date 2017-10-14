class ExchangeRate < ApplicationRecord
  belongs_to :base_currency,
             class_name: 'Currency'

  validates :date, presence: true

  store_accessor :rates
end
