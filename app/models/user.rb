class User < ActiveRecord::Base

  validates_presence_of :name, :description, :twitter_id
  validates :twitter_id, numericality: {only_integer: true}, uniqueness:true 

  # userの情報をDBに加える
  def self.store_db(user)
    # Userテーブルにデータ追加
    User.where(twitter_id: user["id"]).first_or_create(
      name:         user["screen_name"],
      description:  user["description"],
      twitter_id:   user["id"]
    ) 
  end
end
