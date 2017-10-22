require 'rails_helper'

describe Currency, type: :model do
  describe '#create' do
    let(:name) { 'USD' }
    let(:code) { 'USD' }
    let(:currency) { build(:currency, name: name, code: code) }

    context 'code is not provided' do
      let(:code) { nil }

      it 'does not save' do
        expect(currency.save).to eq(false)
      end

      it 'returns correspondent validation error' do
        currency.save
        expect(currency.errors[:code]).not_to be_empty
      end
    end

    context 'name is not provided' do
      let(:name) { nil }

      it 'does not save' do
        expect(currency.save).to eq(false)
      end

      it 'returns correspondent validation error' do
        currency.save
        expect(currency.errors[:name]).not_to be_empty
      end
    end

    context 'all data provided' do
      it 'saves the record' do
        expect(currency.save).to eq(true)
      end
    end
  end
end
