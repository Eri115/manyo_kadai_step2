require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        Task.create!(title: 'タスク書類',content: 'タスクを作成する' )
        visit tasks_path

        expect(page).to have_content('タスク書類')
      end
    end
  end

  describe '一覧表示機能' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: 3.days.ago) }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: 2.days.ago) }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: 1.day.ago) }

  
    before do
      visit tasks_path
    end
  
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が作成日時の降順で表示される' do
        task_titles = all('.task-title td:first-child').map(&:text)
        expect(task_titles).to eq ['third_task', 'second_task', 'first_task']
      end
    end
  
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        #新しいタスクをデータベースに作成
        FactoryBot.create(:task, title: 'new_task', content: '新しいタスクの内容', created_at: Time.now)

        #タスク一覧ページにアクセス
        visit tasks_path

        #すべてのタスクのタイトルをall()を取得し、そのうちの最初のタイトルが 'new_task' であることを期待
        #mapのtask_titleはall('.task-title')でとってきたやつが格納されていて|task_title| に順番に格納されていく仕組み
        task_titles = all('.task-title').map{ |task_title| task_title.find('td:first-child').text }#要素のテキスト内容を取得
        expect(task_titles.first).to eq 'new_task'
      end
    end
  end


  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        task = Task.create!(title:'登録１',content: 'タスク登録完了')
        visit task_path(task)
        
        expect(page).to have_content('登録１')
        expect(page).to have_content('タスク登録完了')
       end
     end
  end
end