class Payment < ApplicationRecord
  has_one :project_status,dependent: :destroy
  before_create :set_status
  def set_status
    self.status="pending"
  end
  before_create :randomize_id
  private
    def randomize_id
        self.id = SecureRandom.random_number(1_000_000_000)
    end
end
