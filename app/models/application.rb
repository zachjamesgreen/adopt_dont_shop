class Application < ApplicationRecord
  belongs_to :pets
  # belongs_to :users
  # enum status: %i[draft reviewed published]
end