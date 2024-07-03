require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { FactoryBot.create(:user) }
    let(:task) { FactoryBot.create(:task) }


    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
      task.title = ''
      task.valid?
      expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task.content = ''
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = FactoryBot.create(:task, title: '書類作成', content: '企画書を作成する')
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', priority: 'high', status: 'working', user: user) }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task_title', priority: 'high', status: 'waiting', user: user) }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task_title', priority: 'high', status: 'completed', user: user) }

  
    context 'scopeメソッドでタイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq 1
      end
    end

    context 'scopeメソッドでステータスで検索した場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_status('working')).to include(first_task)
        expect(Task.search_status('working')).not_to include(second_task)
        expect(Task.search_status('working')).not_to include(third_task)
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end

    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('second')).to include(second_task)
        expect(Task.search_title('first').search_status('working')).not_to include(third_task)
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end
  end
end



