class ProjectMember < ApplicationRecord
  belongs_to :project
  belongs_to :memberable ,polymorphic: true
  before_create :set_status_and_feedback

  def set_status_and_feedback
    self.status="on-process"
    self.feedback=false
  end
  before_create :randomize_id
  private
    def randomize_id
        self.id = SecureRandom.random_number(1_000_000_000)
    end

end
