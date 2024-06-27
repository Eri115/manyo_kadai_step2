# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する。' }
    deadline_on {  Date.new(2022, 2, 18)}
    priority { :medium}
    status { :working}
  end
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
  factory :second_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る。' }
    deadline_on { Date.new(2022, 2, 19) }
    priority { :high}
    status { :waiting}
  end


  factory :third_task, class: Task do
    title { '明日連絡' }
    content { '仕事を休むため事前に連絡' }
    deadline_on { Date.new(2022, 2, 20)}
    priority { :low}
    status { :completed}
  end
end