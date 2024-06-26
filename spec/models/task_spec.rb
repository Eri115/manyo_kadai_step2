require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '',content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(title: '登録する', content: '説明分',created_at: '2024-06-26', deadline_on: '2024-06-27', priority: 'high', status: 'working')
        expect(task).to be_valid
      end
    end
  end

  
  describe '検索機能' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', created_at: '2024-06-26', deadline_on: '2024-06-27', priority: 'high', status: 'working') }
    let!(:second_task) { FactoryBot.create(:task, title: "second_task_title", created_at: '2024-06-26', deadline_on: '2024-06-27', priority: 'high', status: 'waiting') }
    let!(:third_task) { FactoryBot.create(:task, title: "third_task_title", created_at: '2024-06-26', deadline_on: '2024-06-27', priority: 'high', status: 'completed') }

    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        # タイトルの検索メソッドをseach_titleとしてscopeで定義した場合のコード例
        # scopeを使って定義した検索メソッドに検索ワードを挿入する
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq 1
      end
    end
    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do
        expect(Task.search_status('working')).to include(first_task)
        expect(Task.search_status('working')).not_to include(second_task)
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end

    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('second')).to include(second_task)
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end
  end

  context '「優先度」というリンクをクリックした場合' do
    it "優先度の高い順に並び替えられたタスク一覧が表示される" do
      visit tasks_path(task)
      task_lists = all('tbody tr .task-title').map(&:text)
      expect(task_lists).to eq [task2.title, task1.title, task3.title]      # allメソッドを使って複数のテストデータの並び順を確認する
    end
  end
end

