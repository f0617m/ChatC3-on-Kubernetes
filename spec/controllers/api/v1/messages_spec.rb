require 'rails_helper'

describe Api::V1::MessagesController, type: :controller, authentication: :skip do
  before do
    authenticateMock(controller)
  end

  let!(:message) { create(:message) } 
  
  it 'create test data' do
    post 'create', params: { message: { message: message.message, user_id: message.user_id, room_id: message.room_id } }
  end

  it 'GET /getMessages/:id' do
    get 'getMessages', params: { id: message.room_id }

    # res 200
    expect(response.status).to eq 200

    json = JSON.parse(response.body)
    STDOUT.puts json

    #  messageArray確認
    expect(json['message']).to eq 'test message'
  end
end