FactoryBot.define do
    factory :stroke do
      room_id { "1" }
      prevx { "123" }
      prevy { "123" }
      currx { "456" }
      curry { "456" }
      width { "10" }
      color { "#FFFFFF" }
    end
end