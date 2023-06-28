class Skill < ApplicationRecord
  belongs_to :freelancer
  before_create :randomize_id
  before_create :downcase_name

  def downcase_name
    name.downcase!
  end
  private
    def randomize_id
        self.id = SecureRandom.random_number(1_000_000_000)
    end
 validates :name,:level ,presence:true
end


