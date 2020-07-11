require 'rails_helper'

describe Api::V1::MessagesController, type: :controller, authentication: :skip do
  before { authenticateMock(controller) }

  let(:message) { create(:message) }
  post 'create', params: { message: message.message, user_id: message.user_id, room_id: message.room_id }

  it 'GET /getMessages/:id' do
    get 'getMessages', :id => messages.room_id

    # res 200
    expect(response.status).to eq 200
    json = JSON.parse(response.body)
  end
end