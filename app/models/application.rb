class Application < ApplicationRecord
  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validates :desc, presence: true
  # validates :status, presence: true
  belongs_to :pet

  enum status: %w(in_progress pending accepted rejected)
end