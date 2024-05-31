class AddIsOverToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :is_over, :boolean, default: false
  end
end
