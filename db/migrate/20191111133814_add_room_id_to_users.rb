class AddRoomIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :room_id, :string
  end
end
