class AddColumnsToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :deadline_on, :date, null: false, default: ''
    add_column :tasks, :priority, :integer, null: false, default: nil
    add_column :tasks, :status, :integer, null: false, default: nil
  end
end
