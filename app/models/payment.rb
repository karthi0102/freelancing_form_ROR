class Payment < ApplicationRecord
  has_one :project_status,dependent: :destroy
  before_create :set_status
  def set_status
    self.status="pending"
  end
end
