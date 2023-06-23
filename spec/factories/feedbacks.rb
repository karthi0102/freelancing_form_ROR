FactoryBot.define do
  factory :feedback do
      rating {4}
      comment {"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"}
      association :created, factory: :account
      association :recipient,factory: :account


  end
end
