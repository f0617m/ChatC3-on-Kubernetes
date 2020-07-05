require 'test_helper'

class StrokesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stroke = strokes(:one)
  end

  test 'should get index' do
    get strokes_url, as: :json
    assert_response :success
  end

  test 'should create stroke' do
    assert_difference('Stroke.count') do
      post strokes_url, params: { stroke: { color: @stroke.color, currx: @stroke.currx, curry: @stroke.curry, prevx: @stroke.prevx, prevy: @stroke.prevy, room_id: @stroke.room_id, width: @stroke.width } }, as: :json
    end

    assert_response 201
  end

  test 'should show stroke' do
    get stroke_url(@stroke), as: :json
    assert_response :success
  end

  test 'should update stroke' do
    patch stroke_url(@stroke), params: { stroke: { color: @stroke.color, currx: @stroke.currx, curry: @stroke.curry, prevx: @stroke.prevx, prevy: @stroke.prevy, room_id: @stroke.room_id, width: @stroke.width } }, as: :json
    assert_response 200
  end

  test 'should destroy stroke' do
    assert_difference('Stroke.count', -1) do
      delete stroke_url(@stroke), as: :json
    end

    assert_response 204
  end
end
