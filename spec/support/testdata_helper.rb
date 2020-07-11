require 'rails_helper'

module TestDataHelper

  # テストデータの作成
  def createTestData
    # テストデータの登録
    # users
    users = create(:user)
    post "/api/v1/users/", :user_id => users.user_id, :name => users.name, :image_name => users.image_name, :password => users.password

    # rooms
    rooms = create(:room)
    post "/api/v1/rooms/", :status => rooms.status

    # messages
    messages = create(:message)
    post "/api/v1/messages/", :messages => messages.message, :user_id => messages.user_id, :room_id => messages.room_id
  end
end