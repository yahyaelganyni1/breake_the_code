class AddMetadataToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :metadata, :jsonb
  end
end
