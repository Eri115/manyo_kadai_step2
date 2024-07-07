require 'rails_helper'
RSpec.describe 'ラベル管理機能', type: :system do
  describe '登録機能' do
    let!(:label) { FactoryBot.create(:label, user:user) }
    let!(:user) { FactoryBot.create(:user) }
    before do
      visit new_session_path
      fill_in 'session[email]', with: user.email 
      fill_in 'session[password]', with: user.password
      click_button 'ログイン'
    end
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        visit new_label_path
        fill_in 'label[name]', with: 'ラベル1'
        click_button '登録する'
        expect(page).to have_content 'ラベル1'
      end
    end
  end
  describe '一覧表示機能' do
    let!(:label) { FactoryBot.create(:label, user:user) }
    let!(:user) { FactoryBot.create(:user) }

    before do
      visit new_session_path
      fill_in 'session[email]', with: user.email 
      fill_in 'session[password]', with: user.password
      click_button 'ログイン'
    end
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        visit labels_path
        expect(page).to have_content 'ラベル1'
        expect(page).to have_content 'タスク数'
      end
    end
  end
end