# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

currencies = [
  { code: "AUD", name: "Australian Dollar" },
  { code: "BRL", name: "Brazilian Real" },
  { code: "BGN", name: "Bulgarian Lev" },
  { code: "CAD", name: "Canadian Dollar" },
  { code: "CNY", name: "Chinese Yuan Renminbi" },
  { code: "HRK", name: "Croatian Kuna" },
  { code: "CZK", name: "Czech Koruny" },
  { code: "DKK", name: "Danish Kroner" },
  { code: "EUR", name: "Euro" },
  { code: "HKD", name: "Honk Kong Dollar" },
  { code: "HUF", name: "Hungarian Forint" },
  { code: "IDR", name: "Indonesian Rupiah" },
  { code: "CHF", name: "Swiss Francs" },
  { code: "GBP", name: "United Kingdom Pound" },
  { code: "USD", name: "Dollar" }
]

currencies.each do |row|
  Currency.find_or_create_by(row)
end

((Date.today - 25.weeks)..Date.today).each do |date|
  ExchangeRates::Importer.new(date).import!
  sleep 1
end