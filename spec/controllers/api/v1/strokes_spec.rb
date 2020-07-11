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

  it 'POST /getStrokes' do
    get 'getStrokes', params: { id: stroke.room_id }

    # res 200
    expect(response.status).to eq 200

    json = JSON.parse(response.body)

    #  stroke確認
    expect(json['room_id']).to eq '1'
  end

  it 'POST /updateline' do
    post 'draw', params: { stroke: { room_id: stroke.room_id,
                                        prevx: '789',
                                        prevy: '789',
                                        currx: '987',
                                        curry: '987',
                                        width: '5',
                                        color: '#000000'
                                        } }

    # res 200
    expect(response.status).to eq 200
  end
end