require 'rails_helper'

describe Api::V1::RoomsController, type: :controller, authentication: :skip do
  it 'res code 200' do
    get 'find'
    expect(response.status).to eq 200
    json = JSON.parse(response.body)
  end
end