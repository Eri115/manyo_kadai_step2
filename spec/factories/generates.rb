FactoryBot.define do
  factory :generate do
    migration { "MyString" }
    ChangeColumnNullUsers { "MyString" }
  end
end
