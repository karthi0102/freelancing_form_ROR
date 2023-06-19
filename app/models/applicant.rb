class Applicant < ApplicationRecord
  belongs_to :project
  belongs_to :applicable, polymorphic: true

  before_create :randomize_id


  private
    def randomize_id
        self.id = SecureRandom.random_number(1_000_000_000)
    end

end

