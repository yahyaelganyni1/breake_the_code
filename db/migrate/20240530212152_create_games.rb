class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :secret_code
      t.integer :attempts

      t.timestamps
    end
  end
end
