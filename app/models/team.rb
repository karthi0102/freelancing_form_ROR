class Team < ApplicationRecord
  has_and_belongs_to_many :freelancers
  has_one_attached :image
  has_one :team_admin
  has_many :applicants , as: :applicable
  has_many :project_members , as: :memberable
  has_many :projects ,through: :project_members
end


