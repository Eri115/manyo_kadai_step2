require 'rails_helper'

RSpec.describe 'ラベルモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:label) { FactoryBot.create(:label, user:user) }

    context 'ラベルの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        label.name = ''
        label.valid?
        expect(label.errors[:name]).to include("を入力してください")
      end
    end

    context 'ラベルの名前に値があった場合' do
      it 'バリデーションに成功する' do
        label = FactoryBot.create(:label, name: 'ラベル1', user: user)
        expect(label).to be_valid
      end
    end
  end
end
