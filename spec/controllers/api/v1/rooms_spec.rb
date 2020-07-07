require 'rails_helper'

describe Api::V1::RoomsController, type: :controller, authentication: :skip do
  it 'res code 200' do
    authorization = ActionController::HttpAuthentication::Token.encode_credentials('token')
    request.headers.merge!(HTTP_AUTHORIZATION: authorization)
    get 'find'
    expect(response.status).to eq 200
    json = JSON.parse(response.body)
  end
end