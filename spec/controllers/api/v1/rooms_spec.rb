require 'rails_helper'

describe 'Get /getRoom' do
    it 'res code 200' do
        get "/getRoom"
        expect(response.status).to eq 200
        json = JSON.parse(response.body)
    end
end