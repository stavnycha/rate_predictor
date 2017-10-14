class CreateExchangeRates < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_rates do |t|
      t.references :base_currency

      t.date :date
      t.jsonb :rates

      t.timestamps
    end
  end
end
