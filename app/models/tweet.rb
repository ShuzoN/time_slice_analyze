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
end
