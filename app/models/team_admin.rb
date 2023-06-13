class TeamAdmin < ApplicationRecord
  belongs_to :team
  belongs_to :freelancer
end

