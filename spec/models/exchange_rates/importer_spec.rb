require 'rails_helper'

describe ExchangeRates::Importer do
  let(:date) { Date.today }
  let(:base) { create(:currency) }
  let(:importer) { described_class.new(date, base) }

  describe '#import!' do
    let(:importing) do
      VCR.use_cassette('exchange_rates') do
        importer.import!
      end
    end

    context 'imports date rates for the first time' do
      it 'makes api request' do
        expect(RestClient::Request).to receive(:execute).at_least(1).times
        importing
      end

      it 'creates new record of exchange rate in db' do
        expect { importing }.to change { ExchangeRate.count }.from(0).to(1)
      end
    end

    context 'imports date rates for second time' do
      let!(:exchange_rate) do
        create(:exchange_rate, base_currency: base, date: date)
      end

      it 'does not make api request' do
        expect(RestClient::Request).not_to receive(:execute)
        importing
      end

      it 'doesnt create new records of exchange rates' do
        expect { importing }.not_to change { ExchangeRate.count }
      end
    end
  end
end
