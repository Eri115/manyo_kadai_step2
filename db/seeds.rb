# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#5.times do |i|
#  Task.create!(
#    title: "second_task#{i+1}",
#    content: "Content#{i+1}",
#    deadline_on: "2024-02-19",
#    priority: :high,
#   status: :working  )
#end

#5.times do |i|
#  Task.create!(
#    title: "third_task#{i+1}",
#    content: "Content#{i+1}",
#    deadline_on: "2024-02-20",
#    priority: :low,
#    status: :completed
#  )
#end

#5.times do |i|
  #Task.create!(
   #title: "third_task#{i+1}",
    #content: "Content#{i+1}",
   #deadline_on: "2024-02-20",
#    priority: :low,
#    status: :completed
#  )
#end


date_list = ['2025/10/01', '2025/12/01', '2025/01/01', '2025/05/01', '2025/03/01', '2025/11/01', '2025/02/01',
             '2025/09/01', '2025/04/01', '2025/01/01']
priority_list = [2, 0, 2, 1, 1, 0, 1, 2, 1, 2]
status_list = [0, 2, 2, 0, 1, 1, 0, 2, 1, 2]
general_user = User.create!(name: '一般ユーザ', email: 'ippan@aaa.aa', password: '123456', admin: false)
admin_user = User.create!(name: '管理者ユーザ', email: 'kanrisha@aaa.aa', password: '123456', admin: true)
50.times do |n|
  Task.create!(title: "task_title_seed#{n + 1}", content: "task_content_seed#{n + 1}", deadline_on: date_list[n / 10],
               priority: priority_list[n / 10], status: status_list[n / 10], user_id: general_user.id)
end
50.times do |n|
  Task.create!(title: "task_title_seed#{n + 1}", content: "task_content_seed#{n + 1}", deadline_on: date_list[n / 10],
               priority: priority_list[n / 10], status: status_list[n / 10], user_id: admin_user.id)
end