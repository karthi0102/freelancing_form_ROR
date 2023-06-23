FactoryBot.define do
  factory :account do
      sequence :email do |n|
        "test#{n}@gmail.com"
      end
      name {"karthikeyan"}
      phone {"8667259481"}
      linkedin {"https://www.linkedin.com/in/karthikeyanraj/"}
      gender {"male"}
      password { "123456" }
      password_confirmation { "123456" }
      description {"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."}

      trait :for_client do
        association :accountable, factory: :client
    
      end

      trait :for_freelancer do
        association :accountable ,factory: :freelancer

      end

  end
end
