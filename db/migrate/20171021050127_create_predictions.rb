class CreatePredictions < ActiveRecord::Migration[5.1]
  def change
    create_table :predictions do |t|
      t.references :user
      t.references :from_currency
      t.references :to_currency

      t.bigint :amount_fractional
      t.integer :weeks, default: 15

      t.integer :status, default: 0
      t.date  :date
      t.jsonb :rate_history, default: {}
      t.jsonb :rate_prediction, default: {}

      t.timestamps
    end
  end
end
