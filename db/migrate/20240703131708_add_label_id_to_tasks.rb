class AddLabelIdToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :label_id, :integer
    add_index :tasks, :label_id
  end
end
