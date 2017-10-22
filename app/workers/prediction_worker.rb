class PredictionWorker
  include Sidekiq::Worker

  def perform(prediction_id)
    prediction = Prediction.find(prediction_id)
    return if prediction.processed?

    Prediction::Calculator.new(prediction).calculate!
  end
end
