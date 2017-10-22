require 'rails_helper'

describe Prediction::Calculator do
  let(:weeks) { 4 }

  let(:base_currency) { create(:currency) }
  let(:to_currency)   { create(:currency, code: 'EUR', name: 'euro') }
  let(:amount) { 1000 }

  let(:prediction) do
    create(:prediction,
      amount: amount,
      from_currency: base_currency,
      to_currency: to_currency,
      weeks: weeks
    )
  end

  before do
    (weeks + 1).times.each do |i|
      create(:exchange_rate,
        base_currency: base_currency,
        date: Date.today - i.weeks,
        rates: {
          to_currency.code => 1
        }
      )
    end
  end

  describe '#calculate!' do
    let(:history_dates) do
      prediction.rate_history.keys
    end

    let(:forecasted_dates) do
      prediction.rate_prediction.map { |row| row['date'] }
    end

    before do
      prediction.calculate!
      prediction.reload
    end

    it 'set status of prediction to "processed"' do
      expect(prediction.status).to eq('processed')
    end

    let(:expected_history_dates) do
      expected_history_dates = (0..weeks).to_a.map do |week|
        (Date.today - week.weeks)
      end.sort.map(&:to_s)
    end

    it 'saves historical rates, which were involved into forecast' do
      expect(prediction.rate_history).not_to be_empty
      expect(history_dates).to eq(expected_history_dates)
    end

    let(:expected_forecasted_dates) do
      (1..weeks).to_a.map do |week|
        (Date.today + week.weeks)
      end.sort.map(&:to_s)
    end

    it 'saves forecasted rates' do
      expect(prediction.rate_prediction).not_to be_empty
      expect(forecasted_dates).to eq(expected_forecasted_dates)
    end

    it 'sets ranks to forecasted rates' do
      ranks = prediction.rate_prediction.map{ |row| row['rank'] }
      expect(ranks.compact.size).to eq(Prediction::RankSetter::RANKS_AMOUNT)
    end
  end
end
