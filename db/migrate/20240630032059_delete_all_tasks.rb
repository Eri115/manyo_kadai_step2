class DeleteAllTasks < ActiveRecord::Migration[6.1]
  def up
    execute 'DELETE FROM tasks'

  end
 
  def down

  end
 end
