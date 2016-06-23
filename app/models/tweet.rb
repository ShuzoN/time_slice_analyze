class Tweet < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :text, :post_date
  validates :twitter_id, numericality: {only_integer: true}, uniqueness:true 

  # TweetをDBに追加するメソッド
  def self.store_db(tweets) #tw:Hash

    if tweets.size==0 || tweets==nil
      return puts "no data! (Tweet::store_db)" 
    end


    tweets.each do |tw|
      twitter_id        = tw["id"]
      user_twitter_id   = tw["user"]["id"]
      user = User.find_by( twitter_id: user_twitter_id)

      Tweet.where(twitter_id: twitter_id).first_or_create(
        user_id:   user.id,
        text:      tw["text"],
        post_date: Time.zone.parse(tw["created_at"]).to_s(:db)
      )
    end
  end

  # ActiveRecordRelation => String変換を行う
  # scope :group_by_countで取得したレコード群を
  # まとめて, 1つの文字列に変換する
  def self.to_d(tweet_group)
    division_mark = "<div_mark>" # Tweetの区切り
    return tweet_group.pluck(:text).join(division_mark)
  end

  # あるユーザのツイート取得
  scope :find_by_user, ->(user_id){where(user_id: user_id)}

  # 要求された件数でTweetをまとめる
  # 最新ツイートが先頭になるように並びかえ
  # 繰り返せるようにオフセット(埋め合わせ)を設定可能
  scope :group_by_count, ->(user_id, req_count, offset){
    find_by_user(user_id) \
      .order("post_date DESC").limit(req_count).offset(offset)
  }
end
