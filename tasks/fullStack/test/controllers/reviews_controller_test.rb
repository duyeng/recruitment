require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
    @product = products(:one)
    @review = reviews(:one)
  end

  test "should get index" do
    get reviews_url
    assert_response :success
  end

  test "should get new" do
    get new_review_url
    assert_response :success
  end

  test "should create review async" do
    shop = Shop.create!(name: @shop.name, tags: @shop.tags)
    product = Product.create!(shop_id: shop.id, title: @product.title)

    assert_no_difference('Review.count') do
      post reviews_url, params: {
        review: {
          shop_id: shop.id,
          product_id: product.id,
          body: @review.body,
          rating: @review.rating,
          reviewer_name: @review.reviewer_name,
          tags: @review.tags
        }
      }
    end

    assert_redirected_to reviews_url(shop_id: shop.id)
  end
end
