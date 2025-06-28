class AddScoreToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :score, :integer
  end
end
