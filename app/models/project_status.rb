class ProjectStatus < ApplicationRecord
  belongs_to :project
  belongs_to :payment
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

