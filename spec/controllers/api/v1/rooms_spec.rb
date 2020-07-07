require 'spec_helper'

describe 'RoomsController' do
    it 'res code 200' do
        get '/api/v1/getRoom'
        expect(response.status).to eq 200
        json = JSON.parse(response.body)
    end
end