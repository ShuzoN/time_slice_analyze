class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :description
      t.integer :twitter_id, null: false

      t.timestamps null: false
    end
  end
end
