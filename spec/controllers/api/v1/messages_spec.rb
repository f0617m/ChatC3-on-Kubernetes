require 'rails_helper'

describe Api::V1::MessagesController, type: :controller, authentication: :skip do
  before do
    authenticateMock(controller)
    createTestData
  end

  it 'GET /getMessages/:id' do
    get 'getMessages', :id => messages.room_id

    # res 200
    expect(response.status).to eq 200
    json = JSON.parse(response.body)
  end


end