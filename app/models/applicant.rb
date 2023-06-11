class Applicant < ApplicationRecord
  belongs_to :project
  belongs_to :applicable, polymorphic: true
end

