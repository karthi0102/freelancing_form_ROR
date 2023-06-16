module Available
  extend ActiveSupport::Concern
  class_methods do
    def available_project
      where(available: true)
    end
  end
end
