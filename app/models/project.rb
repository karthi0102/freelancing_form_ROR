class Project < ApplicationRecord
  belongs_to :client
  has_one_attached :image
  has_many :applicants
  has_one :project_status
  has_many :project_members
  has_one :payment , through: :project_status
end

