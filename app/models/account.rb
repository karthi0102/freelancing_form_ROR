class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :accountable ,polymorphic: true
  has_one_attached :image ,dependent: :destroy
  has_many :created_feedbacks, class_name: 'Feedback', foreign_key: 'created_id',dependent: :destroy

  has_many :received_feedbacks, class_name: 'Feedback', foreign_key: 'recipient_id' ,dependent: :destroy

  scope :rating_grater_than_3, -> { where('accounts.id IN (?)', Account.pluck(:id).select { |id| Account.find(id).ratings >= 3 }) }
  scope :rating_less_than_3, -> { where('accounts.id IN (?)', Account.pluck(:id).select { |id| Account.find(id).ratings < 3 }) }

  def recipient_feedbacks
    received_feedbacks
  end

  def creator_feedbacks
    created_feedbacks
  end

  def ratings
    average_rating =received_feedbacks.average(:rating)
    if average_rating
     formatted_average_rating =  sprintf('%.2f', average_rating)
     formatted_average_rating.to_f
    else
      0
    end
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

  before_create :randomize_id
  private
    def randomize_id
        self.id = SecureRandom.random_number(1_000_000_000)
    end


  validates :name, length: { in: 5..20 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP ,message:"Invalid Email" }
  validates :phone ,length: {is:10}, numericality: {only_integer:true,greater_than: 0}
  validates :gender, inclusion: { in: %w(male female trasgender others),message: "%{value} is not a valid gender" }
  validates :password, length: {minimum:6,message:"length must be a minimum of 6"}
  validates :description, length: {minimum:20,maximum:500,:too_short=>"is too short",:too_long=>"is too long"}


  def self.authenticate(email,password)
    account = Account.find_for_authentication(email:email)
    account&.valid_password?(password)? account : nil
  end


  has_many :access_tokens,
            class_name: 'Doorkeeper::AccessToken',
            foreign_key: :resource_owner_id,
            dependent: :delete_all #
end
