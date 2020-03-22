class Room < ApplicationRecord
  validates :status, presence: true
end
