class AddMetadataToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :metadata, :jsonb
  end
end
