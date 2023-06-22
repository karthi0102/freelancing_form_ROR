FactoryBot.define do
  factory :project_status do
      status {"on-process"}
      start_date {DateTime.now}
      end_date {nil}
      payment
      project
  end
end
