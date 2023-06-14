class Feedback < ApplicationRecord
  belongs_to :created, class_name: 'Account'
  belongs_to :recipient, class_name: 'Account'
  
end
