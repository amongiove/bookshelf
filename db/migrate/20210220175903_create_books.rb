class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :author_id
      t.integer :created_by #user_id 
    end
  end
end
