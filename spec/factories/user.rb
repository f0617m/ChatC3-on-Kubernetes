FactoryBot.define do
    factory :user do
      user_id { "testuser123" }
      name { "testuser123" }
      image_name { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/image/default.png')) }
      password { 'testuser123' }
    end
end