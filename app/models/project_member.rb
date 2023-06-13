class ProjectMember < ApplicationRecord
  belongs_to :project
  belongs_to :memberable ,polymorphic: true
end
