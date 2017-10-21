class Prediction < ApplicationRecord
  belongs_to :user

  enum status: {
    requested: 0,
    processed: 10,
    failed: 20
  }

  store_accessor :rate_history
  store_accessor :rate_prediction
end
