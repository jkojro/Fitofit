FactoryBot.define do
  sequence(:email) { |n| "user#{n}@fitofit.com" }

  factory :user, class: User do
    email
    password { 'password' }
  end
end
