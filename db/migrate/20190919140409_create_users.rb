class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_id, null: false
      t.string :name, null: false
      t.string :image_name, null: false
      t.string :password_digest, null: false
      t.string :token

      t.timestamps
    end
    add_index :users, :user_id, unique: true
    add_index :users, :token, unique: true
  end
end
