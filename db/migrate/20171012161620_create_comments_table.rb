class CreateCommentsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :user_id
      t.string :post_id
      t.string :comment_content
      t.datetime :created_at
    end
  end
end
