class Tweet < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :text, :post_date, presence: true
  validates :twitter_id, numericality: { only_integer: true }, uniqueness: true

  # TweetをDBに追加するメソッド
  def self.store_db(tweets) # tw:Hash
    if tweets.empty? || tweets.nil?
      return logger.debug "no data! (Tweet::store_db)"
    end

    tweets.each do |tw|
      user = User.find_by(twitter_id: tw["user"]["id"])
      save_if_not_exit(user.id, tw)
    end
  end

  # TweetがDBに存在しない場合, 記録する
  def self.save_if_not_exit(user_id, tweet)
    Tweet.where(twitter_id: tweet["id"]).first_or_create(
      user_id:   user_id,
      text:      tweet["text"],
      post_date: Time.zone.parse(tweet["created_at"]).to_s(:db)
    )
  end

  # ActiveRecordRelation => String変換を行う
  # scope :group_by_countで取得したレコード群を
  # まとめて, 1つの文字列に変換する
  def self.to_d(tweet_group)
    division_mark = "<div_mark>" # Tweetの区切り
    tweet_group.pluck(:text).join(division_mark)
  end

  # あるユーザのツイート取得
  scope :find_by_user, ->(user_id) { where(user_id: user_id) }

  # 要求された件数でTweetをまとめる
  # 最新ツイートが先頭になるように並びかえ
  # 繰り返せるようにオフセット(埋め合わせ)を設定可能
  scope :group_by_count, ->(user_id, req_count, offset){
    find_by_user(user_id) \
      .order("post_date DESC").limit(req_count).offset(offset)
  }
end
