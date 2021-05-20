class Application < ApplicationRecord
  belongs_to :pets
  # belongs_to :users
  enum status: %w(in_progress pending accepted rejected)
end