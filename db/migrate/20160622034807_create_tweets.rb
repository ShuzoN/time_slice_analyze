class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.references :user, index: true, foreign_key: true
      t.bigint :twitter_id
      t.text :text
      t.datetime :post_date

      t.timestamps null: false
    end
  end
end
