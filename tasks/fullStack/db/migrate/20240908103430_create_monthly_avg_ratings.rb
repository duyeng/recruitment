class CreateMonthlyAvgRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :monthly_avg_ratings do |t|
      t.references :shop, null: false, foreign_key: true
      t.integer :total_ratings
      t.integer :total_reviews
      t.float :avg_ratings
      t.date :start_date

      t.timestamps
    end

    add_index :monthly_avg_ratings, [:shop_id, :start_date], unique: true
  end
end
