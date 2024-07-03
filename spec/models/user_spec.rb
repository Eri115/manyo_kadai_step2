require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
  let(:user){FactoryBot.build(:user)}

    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user.name = ''
        user.valid?
        expect(user.errors[:name]).to include('を入力してください')
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user.email = ''
        user.valid?
        expect(user.errors[:email]).to include('を入力してください')
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user.password_digest = ''
        user.valid?
        expect(user.errors[:password]).to include('を入力してください')
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        FactoryBot.create(:user, email: 'user15@xxx.com' )
        user.email = 'user15@xxx.com'
        user.valid?
        expect(user.errors[:email]).to include('はすでに使用されています')

      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user.password = '12345'
        user.valid? 
        expect(user.errors[:password]).to include('は6文字以上で入力してください')
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user.name = 'user'
        user.email = 'user15@xxx.com'
        user.password = '123456'
        user.password_confirmation = '123456'
        user.valid?
        expect(user).to be_valid
      end
    end
  end
end
