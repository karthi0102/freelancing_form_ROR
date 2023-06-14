class Payment < ApplicationRecord
  has_one :project_status,dependent: :destroy
  
end
