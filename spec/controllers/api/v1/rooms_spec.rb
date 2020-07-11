require 'rails_helper'

describe Api::V1::RoomsController, type: :controller, authentication: :skip do
  before { authenticateMock(controller) }

  it 'Get /getroom' do
    get 'find'

    # res 200
    expect(response.status).to eq 200
    json = JSON.parse(response.body)

    # roomデータの返却確認
    expect(json['data']['title']).to eq 'room'
  end
end