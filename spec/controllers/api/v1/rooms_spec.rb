require 'rails_helper'

describe Api::V1::RoomsController, type: :controller, authentication: :skip do
  before { authenticateMock(controller) }

  it 'Get /getroom' do
    get 'find'

    # res 200
    expect(response.status).to eq 200
  end
end