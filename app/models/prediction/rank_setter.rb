class Prediction
  class RankSetter
    attr_reader :prediction

    RANKS_AMOUNT = 3

    def initialize(prediction)
      @prediction = prediction
    end

    def set_ranks!
      @prediction.update(rate_prediction: ranked_rates)
    end

    private

    def ranked_rates
      RANKS_AMOUNT.times.to_a.each do |rank|
        unranked_rates.max_by do |row|
          row['difference']
        end['rank'] = rank + 1
      end
      rate_prediction
    end

    def unranked_rates
      rate_prediction.select do |row|
        row['rank'].blank?
      end
    end

    def rate_prediction
      @rate_prediction ||= prediction.rate_prediction
    end
  end
end
