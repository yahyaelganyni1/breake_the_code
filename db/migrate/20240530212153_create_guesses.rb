class CreateGuesses < ActiveRecord::Migration[7.0]
  def change
    create_table :guesses do |t|
      t.references :game, null: false, foreign_key: true
      t.string :code
      t.string :feedback

      t.timestamps
    end
  end
end
