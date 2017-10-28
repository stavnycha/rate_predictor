require 'libsvm'

#
# Invokes prediction model for rates forecasting and
# stores results in database
#
class Prediction
  class Calculator
    attr_reader :predictor

    def initialize(predictor)
      @predictor = predictor
    end

    def calculate!
      begin
        fetch_history!
        predictor.update(
          status: :processed,
          rate_history: rates_data,
          rate_prediction: predicted_rates
        )
        predictor.set_ranks!
      rescue StandardError => e
        predictor.update(status: :failed)
        raise e if Rails.env.development? || Rails.env.test?
      end
    end

    private

    def fetch_history!
      historical_dates.each do |date|
        ExchangeRates::Importer.new(
          date, predictor.from_currency
        ).import!
      end
    end

    def model
      @model ||= Prediction::Models::Svm.new(rates, predictor.weeks)
    end

    def predicted_rates
      @predicted_rates ||= begin
        model.predicted.map do |week, rate|
          formatted_forecast(prediction_date + week.weeks, rate)
        end
      end
    end

    def prediction_date
      predictor.created_at.to_date
    end

    def formatted_forecast(date, predicted_rate)
      {
        date: date,
        rate: predicted_rate,
        converted_amount: (predicted_rate * amount).to_f,
        difference: (predicted_rate * amount).to_f - (current_rate * amount).to_f
      }
    end

    def amount
      predictor.amount
    end

    def rates
      @rates ||= rates_data.values
    end

    def rates_data
      @rates_data ||= Hash[exchange_rates.map do |r|
        [r.date, r.rates[to_currency]]
      end].compact
    end

    def exchange_rates
      ExchangeRate.where(
        date: historical_dates,
        base_currency: predictor.from_currency
      ).order(:date)
    end

    def current_rate
      @current_rate ||= rates_data[to_date]
    end

    def to_currency
      predictor.to_currency.code
    end

    def historical_dates
      (from_date..to_date).step(7).to_a
    end

    def to_date
      predictor.created_at.to_date
    end

    def from_date
      to_date - predictor.weeks.weeks
    end
  end
end
