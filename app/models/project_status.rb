class ProjectStatus < ApplicationRecord
  belongs_to :project
  belongs_to :payment
  before_create :set_status
  def set_status
    self.status="pending"
  end
end

