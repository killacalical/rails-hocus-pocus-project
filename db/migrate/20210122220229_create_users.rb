class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.text :bio
      t.string :profile_pic

      t.timestamps
    end
  end
end