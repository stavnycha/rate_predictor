module ExchangeRates
  class Importer
    attr_reader :date

    def initialize(date = Date.today)
      @date = date
    end

    def import!
      ExchangeRate.find_or_create_by(
        base_currency: base_currency,
        date: date
      ) do |exchange_rate|
        exchange_rate.rates = parsed_rates
      end
    end

    private

    def parsed_rates
      @parsed_rates ||= request_rate['rates'] || []
    end

    def request_rate
      begin
        JSON.parse(RestClient.get(request_url))
      rescue StandardError
        {}
      end
    end

    def request_url
      "http://api.fixer.io/#{date}?base=#{base_currency.code}"
    end

    def base_currency
      @base_currency ||= Currency.find_by(code: 'USD')
    end
  end
end
