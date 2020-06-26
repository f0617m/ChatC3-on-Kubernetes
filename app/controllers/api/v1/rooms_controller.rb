module Api
  module V1
    class RoomsController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :set_room, only: [:show, :update, :destroy]
      before_action :authenticate

      # GET /rooms
      def index
        @rooms = Room.all

        render json: @rooms
      end

      # GET /rooms/1
      def show
        render json: @room
      end

      # GET /rooms/find
      def find
        @room = Room.where(status: "Waiting").order('created_at ASC').first
        render json: @room
      end

      # POST /rooms
      def create
        @room = Room.new(room_params)

        if @room.save
          render json: @room, status: :created
        else
          render json: @room.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /rooms/1
      def update
        if @room.update(room_params)
          render json: @room
        else
          render json: @room.errors, status: :unprocessable_entity
        end
      end

      # DELETE /rooms/1
      def destroy
        @room.destroy
      end

      def draw
        @stroke = Stroke.new(room_id: params['room_id'], prevx: params['data']['fromx'], prevy: params['data']['fromy'],
           currx: params['data']['tox'], curry: params['data']['toy'], width: params['data']['width'], color: params['data']['color'])
        @stroke.save

        ActionCable.server.broadcast "lines_#{params['room_id']}",
        params
        head :ok
      end

      def authenticate
        authenticate_or_request_with_http_token do |token,options|
          auth_user = User.find_by(token: token)
          auth_user != nil
        end
      end

      private

        # Use callbacks to share common setup or constraints between actions.
        def set_room
          @room = Room.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def room_params
          params.require(:room).permit(:status)
        end
    end
  end
end
