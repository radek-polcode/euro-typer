FactoryBot.define do
  factory :group do
    name { Faker::Movies::LordOfTheRings.character }
    token { "MyString" }
    association :owner, factory: :user
  end
end
