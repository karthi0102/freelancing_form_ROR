class Team < ApplicationRecord
  has_and_belongs_to_many :freelancers
  has_one_attached :image,dependent: :destroy
  belongs_to :admin ,class_name:"Freelancer"
  
  has_many :applicants , as: :applicable,dependent: :destroy
  has_many :project_members , as: :memberable,dependent: :destroy
  has_many :projects ,through: :project_members
end


