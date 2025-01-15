FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    dob { '1990-01-01' }
    address { '123 Test Street' }
    mobile_number { '8834665434' }
    gender { 'Female' }
  end
end
