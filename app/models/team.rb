class Team < ApplicationRecord
  has_and_belongs_to_many :accounts
  has_one_attached :image
  has_one :team_admin
  has_many :applicants , as: :applicable
end
