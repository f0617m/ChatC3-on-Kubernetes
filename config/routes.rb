Rails.application.routes.draw do


  namespace 'api' do
    namespace 'v1' do
      resources :messages, param: :user_id
      resources :users, param: :user_id
      resources :rooms, param: :user_id
      resources :strokes, param: :user_id
      post "/login" => "users#login"
      post "/tokenLogin" => "users#tokenLogin"
      post "/checkPassword" => "users#checkPassword"
      post "/setRoomId" => "users#setRoomId"
      post "/getRoomId" => "users#getRoomId"
      post "/getImageName" => "users#getImageName"
      post "/uploadImage" => "users#uploadImage"
      post "/updateName" => "users#updateName"
      post "/updatePassword" => "users#updatePassword"
      get "/getRoom" => "rooms#find"
      post "/updateline" => "rooms#draw"
      post "/sendMessage" => "messages#talk"
      get "/getMessages/:id" => "messages#getMessages"
      get "/getStroke/:id" => "strokes#getStroke"
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => "/cable"
end
