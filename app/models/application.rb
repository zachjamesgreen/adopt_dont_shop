class Application < ApplicationRecord
  belongs_to :pets
  # belongs_to :users
  enum status: %w[draft reviewed published]
end