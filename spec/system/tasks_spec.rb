require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        Task.create!(title: 'タイトル１', content: '1', created_at: '2024-06-26', deadline_on: '2024-06-27', priority: :high, status: :waiting)
        visit tasks_path

        expect(page).to have_content('タイトル１')
      end
    end
  end


  describe '一覧表示機能' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task',content: 'a', created_at: 3.days.ago, deadline_on: '2024-06-27', priority: :low, status: :waiting) }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', content: 'b', created_at: 2.days.ago, deadline_on: '2024-06-27', priority: :medium, status: :working) }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', content: 'c', created_at: 1.day.ago, deadline_on: '2024-06-29', priority: :high, status: :waiting) }

  
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
        FactoryBot.create(:task, title: 'new_task', content: '新しいタスクの内容', created_at: Time.now, deadline_on: '2024-06-27', priority: :high, status: :waiting)

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
        task = Task.create!(title:'タイトル１',content: 'い', created_at: '2024-06-26', deadline_on: '2024-06-27', priority: 'high', status: 'waiting')
        visit task_path(task)
        
        expect(page).to have_content('タイトル１')
        expect(page).to have_content('い')
       end
     end
  end

  describe 'ソート機能' do
    context '「終了期限」というリンクをクリックした場合' do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do
        # allメソッドを使って複数のテストデータの並び順を確認する
        task_titles = all('.task-title td:first-child').map(&:text)
        expect(task_titles).to eq ['third_task', 'second_task', 'first_task']
      end
    end

  context '「優先度」というリンクをクリックした場合' do
    it "優先度の高い順に並び替えられたタスク一覧が表示される" do
      task_titles = all('.task-title td:first-child').map(&:text)
        expect(task_titles).to eq ['third_task', 'second_task', 'first_task']
      # allメソッドを使って複数のテストデータの並び順を確認する
    end
  end
  
  context 'タイトルであいまい検索をした場合' do
    it "検索ワードを含むタスクのみ表示される" do
      fill_in 'search[title]', with: '作成'
      click_button '検索'
      # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      expect(page).to have_content '書類作成'
      expect(page).not_to have_content 'メール送信'
      expect(page).not_to have_content '会議室予約'
    end
  end
end

