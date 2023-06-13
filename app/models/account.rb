class Account < ApplicationRecord
  belongs_to :accountable ,polymorphic: true
  has_one_attached :image ,dependent: :destroy

end
