class Feedback < ApplicationRecord
  belongs_to :created, class_name: 'Account'
  belongs_to :recipient, class_name: 'Account'
  before_create :randomize_id
  scope :rating_more_than_3 , -> {where("rating >= ?", 3)}
  scope :rating_less_than_3 , -> {where("rating < ?", 3)}
  private
    def randomize_id
        self.id = SecureRandom.random_number(1_000_000_000)
    end
  validates :comment ,length: {minimum:10,maximum:300}
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }


end
