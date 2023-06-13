class Freelancer < ApplicationRecord
  has_one :account , as: :accountable
  has_many :skills
  has_and_belongs_to_many :teams
  has_many :team_admins
  has_many :project_members ,as: :memberable
  has_many :applicants ,as: :applicable
  has_many :projects, through: :project_members

end

