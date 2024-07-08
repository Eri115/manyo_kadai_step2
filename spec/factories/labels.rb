FactoryBot.define do
  factory :label do
    name { 'ラベル1' }
    association :user
  end
end
