require 'active_record'

ActiveRecord::Base.establish_connection(
  "adapter"  => "sqlite3",
  "database" => "./db/twitter.sqlite3"
)

# 使われているSQLを見たいときに使う
# ActiveRecord::Base.logger = Logger.new(STDOUT)

# テーブル名を大文字, 単数形に変える
# これでActiveRecordとオブジェクトが紐づけられる

# Userモデル
class User < ActiveRecord::Base 
  # 値の存在
  validates_presence_of :twitter_id, :name

  has_many :tweets, :dependent => :destroy

  # UserをDBに追加
  def self.storeUser(user) # Hash user
    twitter_id        = user["id"]
    name              = user["screen_name"]
    description       = user["description"]
    puts user["id"]
    # DBにuserが存在しなければuserを追加
    User.where(:name=>name).first_or_create do |u|
      u.twitter_id    = twitter_id
      u.name          = name
      u.description   = description
    end
  end
end 

# Tweetモデル
class Tweet < ActiveRecord::Base
  # 他テーブルの関連
  belongs_to :user
  validates_presence_of :twitter_id, :name

  # TweetをDBに追加するメソッド
  def self.storeTweet(tw) #Hash tweet
    user_name         = tw["user"]["screen_name"]
    user_id           = User.find_by( name: user_name ).id

    Tweet.where(user_id: user_id).first_or_create do |tw|
      tw.user_id     = user_id
      tw.text        = tw["text"]
      tw.post_date   = tw["created_at"]
      tw.save
    end
  end
end

