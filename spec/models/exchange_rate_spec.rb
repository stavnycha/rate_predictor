require 'rails_helper'

describe ExchangeRate, type: :model do
  describe '#create' do
    let(:base) { create(:currency) }
    let(:date) { Date.today }

    let(:exchange_rate) do
      build(:exchange_rate,
        base_currency: base,
        date: date
      )
    end

    context 'date is not provided' do
      let(:date) { nil }

      it 'does not save' do
        expect(exchange_rate.save).to eq(false)
      end

      it 'returns correspondent validation error' do
        exchange_rate.save
        expect(exchange_rate.errors[:date]).not_to be_empty
      end
    end

    context 'base currency is not provided' do
      let(:base) { nil }

      it 'does not save' do
        expect(exchange_rate.save).to eq(false)
      end

      it 'returns correspondent validation error' do
        exchange_rate.save
        expect(exchange_rate.errors[:base_currency]).not_to be_empty
      end
    end

    context 'all data provided' do
      it 'saves the record' do
        expect(exchange_rate.save).to eq(true)
      end
    end
  end
end
