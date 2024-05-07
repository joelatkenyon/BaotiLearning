class Section < ApplicationRecord
  belongs_to :course
  enum content_type: [:text, :image, :video]
end
