class Section < ApplicationRecord
  # Sections belong to courses
  belongs_to :course
  # Sections have many assignments which are destroyed
  # if the section is destroyed
  # One-many relationship
  has_many :assignments, dependent: :destroy

  # Require title so that we have no empty sections
  validates :title, presence: true
end
