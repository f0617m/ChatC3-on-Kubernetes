require 'rails_helper'
require 'messages_spec'

module TestDataHelper

  # テストデータの作成
  def createTestData
    # テストデータの登録
    # user
    user = create(:user)
    post "/api/v1/users/", params: { user_id: user.user_id, name: user.name, image_name: user.image_name, password: user.password }
    # post "/api/v1/users/", :user_id => user.user_id, :name => user.name, :image_name => user.image_name, :password => user.password

    # room
    room = create(:room)
    post "/api/v1/rooms/", :status => room.status

    # message
    message = create(:message)
    post "/api/v1/messages/", :message => message.message, :user_id => message.user_id, :room_id => message.room_id
  end
end