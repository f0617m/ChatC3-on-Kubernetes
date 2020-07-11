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
                                        witdh: stroke.width,
                                        color: stroke.color
                                        } }
  end

  it 'POST /getStrokes' do
    get 'getStrokes', params: { id: stroke.room_id }

    # res 200
    expect(response.status).to eq 200

    json = JSON.parse(response.body)

    #  messageArray確認
    expect(json['room_id']).to eq '1'
  end
end