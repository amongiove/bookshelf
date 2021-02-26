class AddColumn < ActiveRecord::Migration[6.0]
  def change
    add_column(:genres, :category_id, :string)
  end
end
