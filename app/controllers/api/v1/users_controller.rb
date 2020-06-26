module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :set_user, only: [:show, :update, :destroy]
      before_action :authenticate, except: [:create, :login]

      # GET /users
      def index
        @users = User.all

        render json: @users
      end

      # GET /users/1
      def show
        render json: @user
      end

      # POST /users
      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      end

      # POST /login
      def login
        @user = User.find_by(user_id:params[:user_id])

        if (@user && @user.authenticate(params[:password]))
          render json: @user, status: :created
        else
          render plain: "IDまたはパスワードが異なります", status: :unprocessable_entity
        end
      end

      # POST /tokenLogin
      def tokenLogin
        @user = User.find_by(token:params[:token])

        if @user
          render json: @user, status: :created
        else
          render plain: "tokenが不正です", status: :unprocessable_entity
        end 
      end

      # POST /checkPassword
      def checkPassword
        @user = User.find_by(user_id:params[:user_id])

        if (@user && @user.authenticate(params[:password]))
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /users/1
      def update

        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # POST /getRoomId
      def getRoomId
        @user = User.find_by(user_id:params[:user_id])

        render json: @user.room_id if @user?
      end

      #POST /getImageName
      def getImageName
        @user = User.find_by(token:params[:token])

        render json: @user.image_name if @user?
      end

      def uploadImage
        @user = User.find_by(user_id:params[:user_id])

        if @user

          @user.image_name = params[:image_name]
          @user.save

          render json: {
            user_id: @user.user_id,
            image_name: @user.image_name
          }
        end
      end

      def updateName
        @user = User.find_by(user_id:params[:user_id])
        
        if @user
          @user.name = params[:name]
          @user.save!

          render json: {
            user_id: @user.user_id,
            name: @user.name
          }
        end
      end

      def updatePassword
        @user = User.find_by(user_id:params[:user_id])
        if @user
          @user.password = params[:password]
          @user.save!

          render json: {
            user_id: @user.user_id,
            name: @user.password
          }
        end
      end

      # POST /setRoomId
      def setRoomId
        @user = User.find_by(user_id:params[:user_id])
        if @user
          @user.room_id = params[:room_id]
          @user.save
        end
      end

      # DELETE /users/1
      def destroy
        @user.destroy
      end

      def authenticate
        authenticate_or_request_with_http_token do |token,options|
          auth_user = User.find_by(token: token)
          auth_user != nil
        end
      end

      private

        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def user_params
          params.permit(:user_id, :name, :image_name, :password)
          # params.require(:user).permit(:user_id, :name, :image_name, :password)
        end
    end
  end
end
