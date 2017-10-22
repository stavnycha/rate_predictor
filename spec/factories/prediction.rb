FactoryGirl.define do
  factory :prediction do
    association :user
    weeks 10
    amount 100
  end
end
