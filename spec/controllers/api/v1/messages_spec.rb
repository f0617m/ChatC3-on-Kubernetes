require 'rails_helper'

describe 'MessagesController' do
    it 'getMessagesでMessagesを取得する' do

        get '/api/v1/messages/getMessages/1'
        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
    end
end