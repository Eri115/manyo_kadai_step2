require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do

  describe '登録機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin_user) { FactoryBot.create(:admin_user ) }
    let!(:task) { FactoryBot.create(:task, user: user) }

    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        #binding.irb
      
        fill_in 'user[name]', with: 'normal'
        fill_in 'user[email]', with: 'normal@xxx.com'
        fill_in 'user[password]', with: '123456'
        fill_in 'user[password_confirmation]', with: '123456'
        click_button '登録する'

        expect(page).to have_content 'タスク一覧'
      end
    end
    
    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_content 'ログインしてください'
      end
    end

  end

  describe 'ログイン機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin_user) { FactoryBot.create(:admin_user ) }
    let!(:task) { FactoryBot.create(:task, user: user) }

    before do
      visit new_session_path
      fill_in "session[email]", with: user.email
      fill_in "session[password]", with: user.password
      click_button "ログイン"
    end

    context '登録済みのユーザでログインした場合' do
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_content 'ログインしました'
      end

      it '自分の詳細画面にアクセスできる' do
        visit task_path(task.id)
        expect(page).to have_content 'タスク詳細ページ'
      end

      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        other_user = FactoryBot.create(:user, email: 'other_user@example.com')  
        other_task = FactoryBot.create(:task, user: other_user) 
        visit task_path(other_task.id) 
        expect(page).to have_content 'タスク一覧ページ'
      end

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe '管理者機能' do
    let!(:admin_user) { FactoryBot.create(:admin_user ) }
    let!(:user) { FactoryBot.create(:user) }
    #let!(:task) { FactoryBot.create(:task, user: user) }

     context '管理者がログインした場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: admin_user.email
        fill_in "session[password]", with: admin_user.password
        click_button "ログイン"
      end

      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
      end

      it '管理者を登録できる' do
    
        visit new_admin_user_path
        fill_in 'user[name]', with: 'admin50'
        fill_in 'user[email]', with: 'admin50@xxx.com'
        fill_in 'user[password]', with: '123456'
        fill_in 'user[password_confirmation]', with: '123456'
        check 'user[admin]'
        click_button '登録する'

        expect(page).to have_content 'ユーザ一覧ページ'
      end

      it 'ユーザ詳細画面にアクセスできる' do
        visit visit admin_user_path(admin_user.id)
      end

      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(admin_user)
        fill_in 'user[name]', with: 'admin100'
        fill_in 'user[email]', with: 'admin100@xxx.com'
        fill_in 'user[password]', with: '123456'
        fill_in 'user[password_confirmation]', with: '123456'
        click_button '更新する'

        expect(page).to have_content 'ユーザ一覧ページ'
      end

      it 'ユーザを削除できる' do
        visit admin_users_path
        
        # all('tbody tr')[1].click_link '削除' => 削除のリンク
        # page.driver.browser.switch_to.alert.accept

        page.accept_confirm do
          all('tbody tr')[1].click_link '削除'
        end

        expect(page).to have_content 'ユーザ一覧ページ'
      end
     end
    
     context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      let!(:user) { FactoryBot.create(:user) }
      
       it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do

        visit new_session_path
      
        fill_in 'session[email]', with: user.email
        fill_in 'session[password]', with: user.password
        click_button 'ログイン'
        
        visit admin_users_path

        expect(page).to have_content '管理者以外アクセスできません'
       end
     end
   end
end