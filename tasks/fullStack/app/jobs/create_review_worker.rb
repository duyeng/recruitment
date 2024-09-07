class CreateReviewWorker
  include Sidekiq::Worker

  def perform(product_id, body, rating, reviewer_name, tags)
    Review.create!(product_id: product_id, body: body, rating: rating, reviewer_name: reviewer_name, tags: tags)
  end
end
