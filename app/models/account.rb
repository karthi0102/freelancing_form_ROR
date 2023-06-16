class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :accountable ,polymorphic: true
  has_one_attached :image ,dependent: :destroy
  has_many :created_feedbacks, class_name: 'Feedback', foreign_key: 'created_id'

  has_many :received_feedbacks, class_name: 'Feedback', foreign_key: 'recipient_id'
  def recipient_feedbacks
    received_feedbacks
  end
  def creator_feedbacks
    created_feedbacks
  end

  def client?
    if accountable_type=="Client"
      return true
    else
      return false
    end
  end

  def freelancer?
    if accountable_type=="Freelancer"
      return true
    else
      return false
    end
  end

  validates :name, length: { in: 5..30 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP ,message:"Invalid Email" }
  validates :phone ,length: { is:10 ,message:"Invalid Phone Number"}
  validates :gender, inclusion: { in: %w(male female trasgender others),message: "%{value} is not a valid gender" }
  validates :password, length: {minimum:6,message:"length must be a minimum of 6"}
  validates :description, length: {minimum:20,maximum:1500,:too_short=>"is too short",:too_long=>"is too long"}
end
