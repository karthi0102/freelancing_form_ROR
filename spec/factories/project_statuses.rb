FactoryBot.define do
  factory :project_status do
      start_date {DateTime.now}
      end_date {nil}
      payment
      project
  end
end
