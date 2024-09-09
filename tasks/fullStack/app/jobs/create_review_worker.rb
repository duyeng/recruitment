class CreateReviewWorker
  include Sidekiq::Worker

  def perform(shop_id, product_id, body, rating, reviewer_name, tags)
    Review.transaction do
      review = Review.create!(product_id: product_id, body: body, rating: rating, reviewer_name: reviewer_name, tags: tags)
      monthly_avg_rating = MonthlyAvgRating.where(shop_id: shop_id, start_date: review.created_at.beginning_of_month).first
      if monthly_avg_rating.present?
        MonthlyAvgRating.connection.execute <<-SQL
          UPDATE monthly_avg_ratings
          SET total_ratings = total_ratings + #{rating}, total_reviews = total_reviews + 1
          WHERE id = #{monthly_avg_rating.id}
        SQL
      else
        # There is a chance that concurrent jobs may try to insert into this table simultaneously.
        # If this happens, only one job will succeed, while the others will fail and be enqueued for retry.
        # The transaction of the failed jobs will be rolled back, preventing duplicate data from being created.
        # This issue only occurs at the beginning of the month, so it's not a major concern.
        monthly_avg_rating = MonthlyAvgRating.create!(
          shop_id: shop_id, total_ratings: rating, total_reviews: 1, avg_ratings: rating,
          start_date: review.created_at.beginning_of_month
        )
      end
      MonthlyAvgRating.connection.execute <<-SQL
        UPDATE monthly_avg_ratings
        SET avg_ratings = total_ratings / total_reviews
        WHERE id = #{monthly_avg_rating.id}
      SQL
    end
  end
end
