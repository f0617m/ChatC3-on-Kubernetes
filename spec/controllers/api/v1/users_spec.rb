require 'rails_helper'

describe Api::V1::UsersController, type: :controller, authentication: :skip do
  before do
    authenticateMock(controller) 
  end

  let!(:user) { create(:user) }

  it 'create test data' do
    post 'create', params: { user_id: user.user_id, name: user.name, image_name: user.image_name, password: user.password }
  end

  it 'POST /login' do
    post 'login', params: { user_id: user.user_id, password: user.password }

    # res 200
    expect(response.status).to eq 200

    json = JSON.parse(response.body)

    #  login(ユーザID)確認
    expect(json['user_id']).to eq 'testuser123'
  end
end