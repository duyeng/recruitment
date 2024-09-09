class Shop < ApplicationRecord
  has_many :products
  has_many :reviews, through: :products
  has_many :monthly_avg_ratings

  def ratings_change(months)
    today = Date.today
    x_months_ago = today - months.months

    avg_ratings = monthly_avg_ratings
      .where(start_date: x_months_ago.end_of_month..today.end_of_month)

    sorted_ratings = avg_ratings.sort_by { |rating| rating.start_date }

    ratings_change = []
    sorted_ratings.each_cons(2) do |prev, curr|
      change = curr.avg_ratings - prev.avg_ratings
      ratings_change << {
        from: prev.start_date.strftime("%B %Y"),
        to: curr.start_date.strftime("%B %Y"),
        change: change.round(2)
      }
    end

    ratings_change
  end
end
