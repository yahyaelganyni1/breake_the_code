class AddWinnerNameToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :winner_name, :string
  end
end
