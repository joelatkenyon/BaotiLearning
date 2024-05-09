class Assignment < ApplicationRecord
  belongs_to :section

  validates :title, presence: true
  validates :description, presence: true
  validates :opendate, presence: true, comparison: {greater_than: DateTime.current}
  validates :closedate, presence: true, comparison: {greater_than: :opendate}
end
