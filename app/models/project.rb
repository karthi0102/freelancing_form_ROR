class Project < ApplicationRecord
  belongs_to :client
  has_one_attached :image,dependent: :destroy
  has_many :applicants,dependent: :destroy
  has_one :project_status,dependent: :destroy
  has_many :project_members,dependent: :destroy
  has_one :payment , through: :project_status
end

