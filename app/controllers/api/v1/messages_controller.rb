module Api
  module V1
    class MessagesController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :set_message, only: %i[show update destroy]
      before_action :authenticate

      # GET /messages
      def index
        @messages = Message.all

        render json: @messages
      end

      # GET /messages/1
      def show
        render json: @message
      end

      # GET /getMessages/:id
      # room_idに紐づくmessageを全取得
      def getMessages
        @messages = Message.where(room_id: params[:id]).order('created_at ASC')

        messageArray = []

        @messages.each do |message|
          @user = User.find_by(user_id: message.user_id)

          name = ''
          image = ''

          if @user
            name = @user.name
            image = @user.image_name.url
          end

          messageArray.push(
            message: message.message,
            user_id: message.user_id,
            user_name: name,
            image_name: image,
            room_id: message.room_id
          )
        end

        # render json: @messages
        render json: messageArray
      end

      # POST /messages
      def create
        @message = Message.new(message_params)

        if @message.save
          render json: @message, status: :created
        else
          render json: @message.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /messages/1
      def update
        if @message.update(message_params)
          render json: @message
        else
          render json: @message.errors, status: :unprocessable_entity
        end
      end

      # DELETE /messages/1
      def destroy
        @message.destroy
      end

      # POST /sendMessage
      # 新規messageの登録、ActionCableへの送信
      def talk
        @message = Message.new(message: params['message'], user_id: params['user_id'], room_id: params['room_id'])

        return unless @message.save

        render json: @message
        @user = User.find_by(user_id: params['user_id'])

        return if @user.blank?

        params['user_name'] = @user.name
        params['image_name'] = @user.image_name.url

        ActionCable.server.broadcast "messages_#{params['room_id']}", params
        head :ok
      end

      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          auth_user = User.find_by(token: token)
          auth_user != nil
        end
      end

      private

      def set_message
        @message = Message.find(params[:id])
      end

      def message_params
        params.require(:message).permit(:message, :user_id, :room_id)
      end
    end
  end
end
