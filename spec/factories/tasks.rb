# 「FactoryBotを使用します」という記述
FactoryBot.define do
 
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する' }
    deadline_on { Date.tomorrow } 
    priority { 'high' } 
    status { 'working' }
    association :user
  end
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
  
  factory :first_task, class: Task do
    title { 'first_task' }
    content { 'あいうえお' }
    deadline_on { Date.tomorrow } 
    priority { 'low' } 
    status { 'waiting' }
    association :user
  end
  
  factory :second_task, class: Task do
    title { 'second_task' }
    content { 'かきくけこ' }
    deadline_on { '2024-07-06' } 
    priority { 'medium' } 
    status { 'working' }
    association :user
  end

  factory :third_task, class: Task do
    title { 'third_task' }
    content { 'さしすせそ' }
    deadline_on { '2024-07-05' } 
    priority { 'high' } 
    status { 'completed' }
    association :user
  end

  factory :new_task, class: Task do
    title { 'new_task' }
    content { 'さしすせそ' }
    deadline_on { '2024-07-05' } 
    priority { 'high' } 
    status { 'completed' }
    association :user
  end
end

