class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer :book_id
      t.integer :user_id
      t.integer :rating_value
      t.text :review
    end
  end
end
