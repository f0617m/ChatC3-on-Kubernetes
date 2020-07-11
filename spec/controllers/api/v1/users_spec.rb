require 'rails_helper'

describe Api::V1::UsersController, type: :controller, authentication: :skip do
  before { authenticateMock(controller) }

  room = create(:user)
  post 'create', params: { user_id: user.user_id, name: user.name, image_name: user.image_name, password: user.password }

  it 'Get /getroom' do
  end
end