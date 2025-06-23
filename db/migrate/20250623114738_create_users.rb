class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :device_identifier
      t.string :nickname
      t.datetime :last_active

      t.timestamps
    end
  end
end
