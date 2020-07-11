require 'rails_helper'

module TestDataHelper

  # テストデータの作成
  def createTestData
    # テストデータの登録
    # users
    let(:users) { create(:users, user_id: 'testuser123', name: 'testuser123', image_name: 'Default.png', password: 'testuser123') }
    post "/api/v1/users/", :user_id => users.user_id, :name => users.name, :image_name => users.image_name, :password => users.password

    # rooms
    let(:rooms) { create(:rooms, status: 'Waiting') }
    post "/api/v1/rooms/", :status => rooms.status

    # messages
    let(:messages) { create(:messages, message: 'test message', user_id: 'testuser123', room_id: '1') }
    post "/api/v1/messages/", :messages => messages.message, :user_id => messages.user_id, :room_id => messages.room_id
  end
end