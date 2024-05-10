class Assignment < ApplicationRecord
  # Assignments belong to sections
  belongs_to :section

  # Require all fields to prevent empty assignments
  validates :title, presence: true
  validates :description, presence: true
  # Require assignment open datetime to be after the current datetime
  validates :opendate, presence: true, comparison: {greater_than: DateTime.current}
  # Require assignment close datetime to be after its open datetime
  validates :closedate, presence: true, comparison: {greater_than: :opendate}
end
