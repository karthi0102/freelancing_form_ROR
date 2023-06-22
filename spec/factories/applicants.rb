FactoryBot.define do
  factory :applicant do
    status {"applied"}
    project
    trait :for_freelancer do
      association :applicable,
      factory: :freelancer
    end
    trait :for_team do
      association :applicable,
      factory: :team
    end

  end
end
