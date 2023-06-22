FactoryBot.define do
  factory :payment do
    amount {5000}
    status {"pending"}
    account_details {{values:[]}}
  end
end
