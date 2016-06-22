require 'bundler'
Bundler.require

class Main 

  def initialize
    @crawler = Assets::Crawler.new
  end


  def main
  # TwitterAPIから1ユーザのtweetを指定件数 取得
    tweets = @crawler.get_tweets(10)

    user = tweets.first["user"]
    User.store_db(user)

    # tweet モデルがまだない
    # @crawler.store_tweets_to_db(tweets)
  end
end

# クローラを使いDBにTweetを追加する
# 引数は取得するTweet件数
Main.new.main
