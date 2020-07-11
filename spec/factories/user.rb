FactoryBot.define do
    factory :user do
      user_id { "testuser123" }
      name { "testuser123" }
      image_name { "testuser123" }
      password { 'testuser123' }

      # validateチェックのスキップ
      trait :skip_validate do
        to_create {|instance| instance.save(validate: false)}
      end
    end
end