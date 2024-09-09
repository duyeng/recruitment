class Review < ApplicationRecord
  belongs_to :product

  validates :body, presence: true
  validates :product_id, presence: true
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :reviewer_name, presence: true
end
