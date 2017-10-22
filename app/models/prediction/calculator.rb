require 'libsvm'

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
        raise e if Rails.env.development?
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

    def predicted_rates
      @predicted_rates ||= begin
        parameter = Libsvm::SvmParameter.new.tap do |config|
          config.cache_size = 1 # in megabytes
          config.eps = 1
          config.c = 5000
          # [:LINEAR, :POLY, :RBF, :SIGMOID, :PRECOMPUTED]
          config.kernel_type = Libsvm::KernelType::RBF
          config.gamma = 0.002
        end

        prediction_dates.map do |date|
          x_data = (rates.size - lag).times.map do |i|
            lag.times.to_a.map do |j|
              rates[i + j]
            end.to_example
          end

          y_data = rates[lag..-1]

          problem = Libsvm::Problem.new
          problem.set_examples(y_data, x_data)

          model = Libsvm::Model.train(problem, parameter)
          predicted = model.predict(rates[-5..-1].to_example)

          rates.push(predicted)
          formatted_forecast(date, predicted / fractional_coef)
        end
      end
    end

    def formatted_forecast(date, predicted_rate)
      {
        date: date,
        rate: predicted_rate,
        converted_amount: (predicted_rate * amount).to_f,
        difference: (predicted_rate * amount).to_f - (current_rate * amount).to_f
      }
    end

    def lag
      5
    end

    def fractional_coef
      1000000.0
    end

    def prediction_dates
      @prediction_dates ||= begin
        from = Date.today + 1.day
        to = from + predictor.weeks.weeks
        (from..to).step(7).to_a
      end
    end

    def amount
      predictor.amount
    end

    def start_date
      predictor.created_at
    end

    def dates
      @dates ||= rates_data.keys
    end

    def rates
      @rates ||= rates_data.values.map do |r|
        r * fractional_coef
      end
    end

    def min_date
      @min_date ||= dates.min
    end

    def rates_data
      @rates_data ||= Hash[exchange_rates.map do |r|
        [r.date, r.rates[to_currency]]
      end].compact
    end

    def exchange_rates
      ExchangeRate.where(date: historical_dates)
        .where(base_currency: predictor.from_currency)
    end

    def current_rate
      @current_rate ||= rates_data[predictor.created_at.to_date]
    end

    def to_currency
      predictor.to_currency.code
    end

    def from_date
      Date.today - predictor.weeks.weeks
    end

    def historical_dates
      (from_date..Date.today).step(7).to_a
    end
  end
end
