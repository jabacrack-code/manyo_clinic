class Task < ApplicationRecord
  # Validation rules for Task model
  validates :title, presence: true
  validates :content, presence: true
end
