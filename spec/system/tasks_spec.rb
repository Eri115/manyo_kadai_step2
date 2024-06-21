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
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        #Task.create!(title:'登録１',content: 'タスク登録完了')
        #Task.create!(title:'登録２',content: 'タスク登録完了')
        FactoryBot.create(:task)
        visit tasks_path

        binding.irb
        expect(page).to have_content('企画の予算案を作成する。')
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