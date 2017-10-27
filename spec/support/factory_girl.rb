RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do
  sequence :email do |n|
    "#{n}@example.com"
  end
end
