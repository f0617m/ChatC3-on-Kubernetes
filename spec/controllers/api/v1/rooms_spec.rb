require 'rails_helper'

describe Api::V1::RoomsController, type: :controller, authentication: :skip do
  before do
    authenticateMock(controller)
    room = create(:room)
    post 'create', params: { status: room.status }
  end

  it 'Get /getroom' do
    get 'find'

    # res 200
    expect(response.status).to eq 200
  end
end