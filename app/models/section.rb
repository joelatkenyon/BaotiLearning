class Section < ApplicationRecord
  belongs_to :course
  has_many :assignments, dependent: :destroy

  validates :title, presence: true
end
