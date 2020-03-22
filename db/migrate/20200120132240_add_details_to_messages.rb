class AddDetailsToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :user_id, :string
    add_column :messages, :room_id, :string
  end
end
