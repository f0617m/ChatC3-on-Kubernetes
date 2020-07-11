module Api
  module V1
    class StrokesController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :set_stroke, only: %i[show update destroy]
      before_action :authenticate

      # GET /strokes
      def index
        @strokes = Stroke.all

        render json: @strokes
      end

      # GET /strokes/1
      def show
        render json: @stroke
      end

      # POST /getStrokes
      def getStrokes
        @strokes = Stroke.where(room_id: params[:id]).order('created_at ASC')

        render json: @strokes
      end

      # POST /strokes
      def create
        @stroke = Stroke.new(stroke_params)

        if @stroke.save
          render json: @stroke, status: :created, location: @stroke
        else
          render json: @stroke.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /strokes/1
      def update
        if @stroke.update(stroke_params)
          render json: @stroke
        else
          render json: @stroke.errors, status: :unprocessable_entity
        end
      end

      # DELETE /strokes/1
      def destroy
        @stroke.destroy
      end

      # POST /updateline
      def draw
        @stroke = Stroke.new(
          room_id: params['room_id'],
          prevx: params['data']['fromx'],
          prevy: params['data']['fromy'],
          currx: params['data']['tox'],
          curry: params['data']['toy'],
          width: params['data']['width'],
          color: params['data']['color']
        )

        @stroke.save

        ActionCable.server.broadcast "lines_#{params['room_id']}", params
        head :ok
      end

      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          auth_user = User.find_by(token: token)
          auth_user != nil
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_stroke
        @stroke = Stroke.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def stroke_params
        params.require(:stroke).permit(:room_id, :prevx, :prevy, :currx, :curry, :width, :color)
      end
    end
  end
end
