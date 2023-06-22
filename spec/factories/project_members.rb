FactoryBot.define do
  factory :project_member do
    feedback {false}
    status {"on-process"}
    trait :for_freelancer do
      association :memberable,
      factory: :freelancer
    end
    trait :for_team do
      association :memberable,
      factory: :team
    end

  end
end
