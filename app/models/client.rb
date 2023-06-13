class Client < ApplicationRecord
  has_one :account , as: :accountable,dependent: :destroy
  has_many :projects ,dependent: :destroy

end
