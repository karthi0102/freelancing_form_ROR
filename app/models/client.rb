class Client < ApplicationRecord
  has_one :account , as: :accountable, dependent: :destroy
  has_many :projects ,dependent: :destroy

  scope :has_more_than_5_projects, -> { joins(:projects).group(:id).having("COUNT(projects.id) >= 5") }
  scope :has_less_than_5_projects, -> { joins(:projects).group(:id).having("COUNT(projects.id) < 5") }
  validates :company ,:company_location ,presence:true
  before_create :randomize_id
  private
    def randomize_id
        self.id = SecureRandom.random_number(1_000_000_000)
    end

end
