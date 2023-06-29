class Project < ApplicationRecord
  paginates_per 4
  include Available
  belongs_to :client
  has_one_attached :image,dependent: :destroy
  has_many :applicants,dependent: :destroy
  has_one :project_status ,dependent: :destroy
  has_many :project_members,dependent: :destroy
  has_one :payment , through: :project_status
  scope :available, -> { where(:available => true) }
  scope :unavailable, -> {where(:available => false)}

  validates :name, length: { in: 5..20 ,message:"should minimum of 5 and maximum of 30 characters" }
  validates :description , length: {minimum:20,maximum:500}
  validates :amount, numericality: {only_integer:true,greater_than_or_equal_to: 5000}

  before_create :set_available

  def set_available
    self.available=true
  end

  def applicants_with_status(status)
    applicants.where(status: status)
  end
  before_create :randomize_id
  private
    def randomize_id
        self.id = SecureRandom.random_number(1_000_000_000)
    end

end

