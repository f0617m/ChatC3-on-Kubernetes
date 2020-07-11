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

    #  messageArray確認
    expect(json[0]['message']).to eq 'test message'
  end

  it 'POST /sendMessage' do
    post 'talk', params: { message: { message: 'talk test', user_id: 'testuser123', room_id: '1' } }

    # res 200
    expect(response.status).to eq 200
  end
end