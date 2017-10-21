require 'libsvm'

class Prediction
  class Calculator
    attr_reader :predictor

    def initialize(predictor)
      @predictor = predictor
    end

    def calculate!
      begin
        predictor.update(
          status: :processed,
          rate_history: rates_data,
          rate_prediction: predicted_rates
        )
      rescue StandardError => e
        predictor.update(status: :failed)
        raise e if Rails.env.development?
      end
    end

    private

    def predicted_rates
      @predicted_rates ||= begin
        problem = Libsvm::Problem.new
        parameter = Libsvm::SvmParameter.new

        parameter.cache_size = 1 # in megabytes

        parameter.eps = 0.001
        parameter.c = 10

        examples = dates.map { |d| Libsvm::Node.features([transform_date(d)]) }
        problem.set_examples(rates, examples)
        model = Libsvm::Model.train(problem, parameter)

        Hash[prediction_dates.map do |date|
          [date, model.predict(Libsvm::Node.features([transform_date(date)]))]
        end]
      end
    end

    def prediction_dates
      @prediction_dates ||= begin
        from = Date.today + 1.day
        to = from + predictor.weeks.weeks
        (from..to).to_a
      end
    end

    def transform_date(date)
      (date - min_date).to_i
    end

    def start_date
      predictor.created_at
    end

    def dates
      @dates ||= rates_data.keys
    end

    def rates
      @rates ||= rates_data.values
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
      ExchangeRate.where('date <= ?', from_date)
        .where(base_currency: predictor.from_currency)
    end

    def to_currency
      predictor.to_currency.code
    end

    def from_date
      Date.today - predictor.weeks.weeks
    end
  end
end

