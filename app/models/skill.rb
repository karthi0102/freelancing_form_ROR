class Skill < ApplicationRecord
  belongs_to :freelancer
  before_create :randomize_id
  private
    def randomize_id
        self.id = SecureRandom.random_number(1_000_000_000)
    end
 validates :name,:skill ,presence:true
end


