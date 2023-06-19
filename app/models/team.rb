class Team < ApplicationRecord
  has_and_belongs_to_many :freelancers
  has_one_attached :image,dependent: :destroy
  belongs_to :admin ,class_name:"Freelancer"

  has_many :applicants , as: :applicable,dependent: :destroy
  has_many :project_members , as: :memberable,dependent: :destroy
  has_many :projects ,through: :project_members
  before_create :randomize_id
  private
    def randomize_id
        self.id = SecureRandom.random_number(1_000_000_000)
    end

    validates :name ,length: {minimum:5,maximum:20}
    validates :description ,length: {minimum:20,maximum:3000}

end


