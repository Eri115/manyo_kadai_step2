# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#Task.create!(title: "first_task", content: "1")

#5.times do |i|
  #Task.create(title: "first_task#{i+1}", content: "Content#{i+1}",deadline_on:"2024-2-18", priority: :medium, status: :waiting)
#end

#5.times do |i|
  #Task.create(title: "second_task#{i+1}", content: "Content#{i+1}",deadline_on:"2024-2-19", priority: :high, status: :working)
#end

#5.times do |i|
  #Task.create(title: "third_task#{i+1}", content: "Content#{i+1}",deadline_on:"2024-2-20", priority: :low, status: :completed)
#end

user = FactoryBot.create(:user, email: 'user@example.com')

# 管理者の作成
admin = FactoryBot.create(:admin_user, email: 'admin@example.com')

# 一般ユーザーに関連付けられたタスクの生成
50.times do
  FactoryBot.create(:task, user: user)
end

# 管理者に関連付けられたタスクの生成
50.times do
  FactoryBot.create(:task, user: admin)
end