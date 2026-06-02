class AddDifficultyAndHintsToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :difficulty, :string, default: "normal", null: false
    add_column :games, :hints_used, :integer, default: 0, null: false
  end
end
