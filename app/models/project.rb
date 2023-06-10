class Project < ApplicationRecord
  belongs_to :account
  has_one_attached :image
  has_many :applicants
end
