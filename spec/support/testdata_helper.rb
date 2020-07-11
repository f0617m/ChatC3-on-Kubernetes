require 'rails_helper'

module TestDataHelper

  # テストデータの作成
  def createTestData
    # テストデータの登録
    # user
    user = create(:user, :skip_validate)
    post "/api/v1/users/", :user_id => user.user_id, :name => user.name, :image_name => user.image_name, :password => user.password

    # room
    room = create(:room)
    post "/api/v1/room/", :status => room.status

    # message
    message = create(:message)
    post "/api/v1/message/", :message => message.message, :user_id => message.user_id, :room_id => message.room_id
  end
end