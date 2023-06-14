class Project < ApplicationRecord
  belongs_to :client
  has_one_attached :image,dependent: :destroy
  has_many :applicants,dependent: :destroy
  has_one :project_status
  has_many :project_members,dependent: :destroy
  has_one :payment , through: :project_status
  validates :name, length: { in: 5..30 ,message:"should minimum of 5 and maximum of 30 characters" }
end

