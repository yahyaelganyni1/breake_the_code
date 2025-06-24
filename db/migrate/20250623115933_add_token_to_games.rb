class AddTokenToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :token, :string
    add_index :games, :token, unique: true
  end
end
