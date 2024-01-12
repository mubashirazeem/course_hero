class School < ApplicationRecord
  has_many :users
  has_many :pdfs, through: :users
end
