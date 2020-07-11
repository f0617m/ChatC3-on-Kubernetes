FactoryBot.define do
    factory :messages, class: Messages do
      message { "test message" }
      user_id { "testuser123" }
      room_id { "1" }
    end
end