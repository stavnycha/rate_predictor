class Prediction < ApplicationRecord
  belongs_to :user

  enum status: {
    requested: 0,
    processed: 10,
    failed: 20
  }

  belongs_to :from_currency,
             class_name: 'Currency'

  belongs_to :to_currency,
             class_name: 'Currency'

  store_accessor :rate_history
  store_accessor :rate_prediction

  monetize :amount_fractional, as: :amount
           with_model_currency: :from_currency

  validates :weeks, numericality: { less_than_or_equal_to: 25 }
end
