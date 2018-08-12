class Item < ApplicationRecord
  belongs_to :list
  belongs_to :completed_by, class_name: "User", optional: true

  def info
    if self.is_done && self.completed_by && self.completed_at
      "Completed by #{self.completed_by.full_name} at #{self.completed_at.to_formatted_s(:time)} on #{self.completed_at.to_formatted_s(:month_day_comma_year)}"
    else
      "Item not yet completed."
    end
  end
end
