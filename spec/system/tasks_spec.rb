require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do

  describe '登録機能' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      visit new_session_path
      fill_in 'session[email]', with: user.email 
      fill_in 'session[password]', with: user.password
      click_button 'ログイン'
    end

    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit tasks_path
        click_link '新規作成'
        fill_in 'task[title]', with: 'テスト'
        fill_in 'task[content]', with: '旅行の予定を立てる'
        fill_in 'task[deadline_on]', with: Date.new(2024, 7, 2)
        select '高', from: 'task[priority]'
        select '未着手', from: 'task[status]'
        click_button '登録する'

        expect(page).to have_content 'テスト'
        expect(page).to have_content '旅行の予定を立てる'
        expect(page).to have_content '2024'
        expect(page).to have_content '7'
        expect(page).to have_content '2'
        expect(page).to have_content '高'
        expect(page).to have_content '未着手'
      end
    end
  end

  describe '一覧表示機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_task) { FactoryBot.create(:first_task, user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, user: user) }

    before do
      visit new_session_path
      fill_in 'session[email]', with: user.email 
      fill_in 'session[password]', with: user.password
      click_button 'ログイン'
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
       
        new_task = FactoryBot.create(:new_task, user: user)

        visit tasks_path

        #すべてのタスクのタイトルをall()を取得し、そのうちの最初のタイトルが 'new_task' であることを期待
        #mapのtask_titleはall('.task-title')でとってきたやつが格納されていて|task_title| に順番に格納されていく仕組み
        task_titles = all('.task-title').map{ |task_title| task_title.find('td:first-child').text }#要素のテキスト内容を取得
        expect(task_titles.first).to eq 'new_task'
      end
    end
  end

  describe '詳細表示機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, user: user) }

    before do
      visit new_session_path
      fill_in 'session[email]', with: user.email 
      fill_in 'session[password]', with: user.password
      click_button 'ログイン'
      visit tasks_path
    end

     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        #task = FactoryBot.create(:task, user: user)
        visit task_path(task)
        
        expect(page).to have_content(task.title)
        expect(page).to have_content(task.content)
       end
     end
  end

  describe 'ソート機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_task) { FactoryBot.create(:first_task, user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, user: user) }

    before do
      visit new_session_path
      fill_in 'session[email]', with: user.email 
      fill_in 'session[password]', with: user.password
      click_button 'ログイン'
      visit tasks_path
    end

    context '「終了期限」というリンクをクリックした場合' do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do

        click_link '終了期限'
        sleep 0.1
        task_titles = all('.task-title td:first-child').map(&:text)
        expect(task_titles).to eq ['third_task', 'second_task', 'first_task']
      end
    end

    context '「優先度」というリンクをクリックした場合' do
      it "優先度の高い順に並び替えられたタスク一覧が表示される" do

        click_link '優先度'
        sleep 0.1
        task_titles = all('.task-title td:first-child').map(&:text)
        expect(task_titles).to eq ['third_task', 'second_task', 'first_task']
      end
    end
  end

  describe '検索機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, user: user) }
    
    before do
      visit new_session_path
      fill_in 'session[email]', with: user.email 
      fill_in 'session[password]', with: user.password
      click_button 'ログイン'
      visit tasks_path
    end

    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        
        fill_in 'title', with: '作成'
        click_button '検索'
        expect(page).to have_content '書類作成'
        expect(page).to have_content '企画書を作成する'
      end
    end

    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do
       
        select '着手中', from: 'status'
        click_button '検索'
        expect(page).to have_content '書類作成'
        expect(page).to have_content '企画書を作成する'
      end
    end

    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do

        fill_in 'title', with: '作成'
        select '着手中', from: 'status'
        
        expect(page).to have_content '書類作成'
        expect(page).to have_content '企画書を作成する'
    
      end
    end
  end
end
