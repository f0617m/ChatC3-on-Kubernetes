require 'rails_helper'

describe RoomsController do
    it 'res code 200' do
        get 'find'
        expect(response.status).to eq 200
        json = JSON.parse(response.body)
    end
end