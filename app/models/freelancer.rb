class Freelancer < ApplicationRecord
  has_one :account , as: :accountable,dependent: :destroy
  has_many :skills,dependent: :destroy
  has_and_belongs_to_many :teams
  has_many :team_admins,class_name:"Team",foreign_key:"admin_id"
  accepts_nested_attributes_for :account
  has_many :project_members ,as: :memberable,dependent: :destroy
  has_many :applicants ,as: :applicable,dependent: :destroy
  has_many :projects, through: :project_members

  def team_admin
    team_admins
  end
  validates :github ,presence: true
  validates :experience ,length: {minimum:20,maximum:1500,:too_short=>"is too short",:too_long=>"is too long"}
end

