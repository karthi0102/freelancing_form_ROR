class Account < ApplicationRecord
  has_many :skills
  has_many :projects
  has_one_attached :image
  has_and_belongs_to_many :teams
  has_many :applicants
end

