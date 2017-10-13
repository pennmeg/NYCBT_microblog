class CreateUsersTable < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :fname
      t.string :lname
      t.string :password
      t.string :email
      t.string :membertype
      t.datetime :created_at
    end
  end
end
