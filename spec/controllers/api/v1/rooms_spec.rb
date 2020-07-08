require 'rails_helper'

describe Api::V1::RoomsController, type: :controller, authentication: :skip do
  before do
    allow(Api::V1::RoomsController).to receive(:authentication).and_return(true)
  end

  it 'test' do
    expect(200).to eq 200
  end

  it 'res code 200' do
    get 'find'
    expect(response.status).to eq 200
    json = JSON.parse(response.body)
  end
end