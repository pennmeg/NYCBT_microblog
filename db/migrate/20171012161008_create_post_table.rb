class CreatePostTable < ActiveRecord::Migration[5.1]
  def change
    create_table :post do |t|
      t.string :user_id
      t.string :post_title
      t.string :post_content
      t.datetime :created_at
    end
  end
end
