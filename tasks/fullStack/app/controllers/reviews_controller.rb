class ReviewsController < ApplicationController

  DEFAULT_TAGS = ['default']

  def index
    if params[:shop_id].present? && Shop.where("id = #{params[:shop_id]}").present?
      params[:per_page] ||= 10
      offset = params[:page].to_i * params[:per_page]

      @data = []
      products = Product.where("shop_id = #{params[:shop_id]}").sort_by(&:created_at)[offset..(offset + params[:per_page])]
      products.each do |product|
        reviews = product.reviews.sort_by(&:created_at)[offset..(offset + params[:per_page])]
        @data << { product: product, reviews: reviews }
      end
    end
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # POST /reviews
  def create
    product = Product.find_by(shop_id: review_params[:shop_id], id: review_params[:product_id])
    @review = Review.new(review_params.except(:shop_id))

    if product.present? && @review.valid?
      tags = tags_with_default(product, review_params)
      CreateReviewWorker.perform_async(review_params[:product_id], review_params[:body], review_params[:rating], review_params[:reviewer_name], tags)

      flash[:notice] = 'Review is being created in background. It might take a moment to show up'
      redirect_to action: :index, shop_id: review_params[:shop_id]
    else
      render action: :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:shop_id, :product_id, :body, :rating, :reviewer_name, :tags)
  end

  # Prepend `params[:tags]` with tags of the shop (if present) or DEFAULT_TAGS
  # For simplicity, let's skip the frontend for `tags`, and just assume frontend can somehow magically send to backend `params[:tags]` as a comma-separated string
  # The logic/requirement of tags is that:
  #  - A review can have `tags` (for simplicity, tags are just an array of strings)
  #  - If the shop has some `tags`, those tags of the shop should be part of the review's `tags`
  #  - Else (if the shop doesn't have any `tags`), the default tags (in constant `DEFAULT_TAGS`) should be part of the review's `tags`
  # One may wonder what an odd logic and lenthy comment, thus may suspect something hidden here, an easter egg perhaps.
  def tags_with_default(product, params)
    default_tags = product.shop.tags || DEFAULT_TAGS
    default_tags.concat(params[:tags]&.split(',') || []).uniq
  end
end
