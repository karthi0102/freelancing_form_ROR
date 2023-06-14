class Account < ApplicationRecord
  belongs_to :accountable ,polymorphic: true
  has_one_attached :image ,dependent: :destroy
  has_many :created_feedbacks, class_name: 'Feedback', foreign_key: 'created_id'
  accepts_nested_attributes_for :client ,:freelancer
  has_many :received_feedbacks, class_name: 'Feedback', foreign_key: 'recipient_id'
  def recipient_feedbacks
    received_feedbacks
  end
  def creator_feedbacks
    created_feedbacks
  end

  validates :name, length: { in: 5..30 }
end
