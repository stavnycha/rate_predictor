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

  monetize :amount_fractional, as: :amount,
           with_model_currency: :from_currency_code

  delegate :code, to: :from_currency, prefix: true, allow_nil: true

  validates :weeks, presence: true,
            numericality: { less_than_or_equal_to: 25 }

  after_commit :calculate_prediction, on: :create

  validate :validate_currencies

  private

  def calculate_prediction
    PredictionWorker.perform_async(id)
  end

  def validate_currencies
    if from_currency == to_currency
      errors.add :to_currency, :same_as_base
    end
  end
end
