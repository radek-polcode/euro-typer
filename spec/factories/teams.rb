# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :team do
    name { 'Polska nazwa' }
    name_en { Faker::Address.country }
    
    trait :with_photo do
      photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/photo.jpg'), 'image/jpeg') }
    end
  end
end
