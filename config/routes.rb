Rails.application.routes.draw do


  namespace 'api' do
    namespace 'v1' do
      resources :messages
      resources :users
      resources :rooms
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
      get "/getStroke/:id" => "strokes#getStroke"
      get "/getMessages/:id" => "messages#getMessages"
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => "/cable"
end
