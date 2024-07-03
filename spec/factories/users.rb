FactoryBot.define do

  factory :user do
    name { "user" }
    email { "user15@xxx.com" }
    password { "123456" }
    password_confirmation { "123456" }

    trait :admin do
      admin { true }
    end
  end
  
  factory :admin_user, parent: :user do
    name { "admin3" }
    email { "admin3@xxx.com" }
    password { "123456" }
    password_confirmation { "123456" }
    admin { true }
  end
end
