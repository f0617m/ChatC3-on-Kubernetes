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

    # res 201
    expect(response.status).to eq 201

    json = JSON.parse(response.body)

    #  login(ユーザID)確認
    expect(json['user_id']).to eq 'testuser123'
  end

  it 'POST /checkPassword' do
    post 'checkPassword', params: { user_id: user.user_id, password: user.password }

    # res 200
    expect(response.status).to eq 200
  end

  it 'GET /getRoomId' do
    get 'getRoomId', params: { user_id: user.user_id }

    # res 200
    expect(response.status).to eq 200
  end

  it 'POST /uploadImage' do
    post 'uploadImage', params: { user_id: user.user_id, image_name: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/image/default2.png')) }

    # res 200
    expect(response.status).to eq 200
  end

  it 'POST /updateName' do
    post 'updateName', params: { user_id: user.user_id, name: 'testuser456' }

    # res 200
    expect(response.status).to eq 200
  end

  it 'POST /updatePassword' do
    post 'updatePassword', params: { user_id: user.user_id, password: 'testuser456' }

    # res 200
    expect(response.status).to eq 200
  end

  it 'POST /setRoomId' do
    post 'setRoomId', params: { user_id: user.user_id, room_id: '1' }

    # res 204
    expect(response.status).to eq 204
  end
end