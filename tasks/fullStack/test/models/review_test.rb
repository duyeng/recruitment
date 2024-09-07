require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  setup do
    @shop = shops(:one)
    @product = products(:one)
    @review = reviews(:one)
  end

  test "should not save review without product" do
    review = Review.new(body: @review.body, rating: @review.rating, reviewer_name: @review.reviewer_name)
    assert_not review.save, "Saved the review without product"
  end

  test "should not save review without body" do
    product = create_product
    review = Review.new(product_id: product.id, rating: @review.rating, reviewer_name: @review.reviewer_name)
    assert_not review.save, "Saved the review without body"
  end

  test "should not save review without rating" do
    product = create_product
    review = Review.new(product_id: product.id, body: @review.body, reviewer_name: @review.reviewer_name)
    assert_not review.save, "Saved the review without rating"
  end

  test "should not save review without reviewer" do
    product = create_product
    review = Review.new(product_id: product.id, body: @review.body, rating: @review.rating)
    assert_not review.save, "Saved the review without reviewer"
  end

  test "should create review successfully" do
    product = create_product
    review = Review.new(product_id: product.id, body: @review.body, rating: @review.rating, reviewer_name: @review.reviewer_name)
    assert review.save, "Failed to create review"
  end

  def create_product
    shop = Shop.create!(name: @shop.name, tags: @shop.tags)
    Product.create!(shop_id: shop.id, title: @product.title)
  end
end
