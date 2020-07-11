require 'rails_helper'

describe Api::V1::StrokesController, type: :controller, authentication: :skip do
  before do
    authenticateMock(controller)
  end

  let!(:stroke) { create(:stroke) }

  it 'create test data' do
    post 'create', params: { stroke: { room_id: stroke.room_id,
                                        prevx: stroke.prevx,
                                        prevy: stroke.prevy,
                                        currx: stroke.currx,
                                        curry: stroke.curry,
                                        width: stroke.width,
                                        color: stroke.color
                                        } }
  end

  it 'GET /getStroke/:id' do
    get 'getStroke', params: { id: stroke.room_id }

    # res 200
    expect(response.status).to eq 200

    json = JSON.parse(response.body)

    STDOUT.puts json

    #  stroke確認
    expect(json['room_id']).to eq '1'
  end

  it 'POST /updateline' do
    post 'draw', params: { stroke: { data: { room_id: stroke.room_id,
                                            fromx: '789',
                                            fromy: '789',
                                            tox: '987',
                                            toy: '987',
                                            width: '5',
                                            color: '#000000'
                                        } } }

    # res 200
    expect(response.status).to eq 200
  end
end