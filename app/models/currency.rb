class Currency < ApplicationRecord
  validates :name, :code, presence: true
end
