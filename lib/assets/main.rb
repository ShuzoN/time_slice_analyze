require 'bundler'
Bundler.require

require File.expand_path('../crawler.rb', __FILE__)

class Main 

  # TwitterAPIから取得したtweetを
  # DataBaseに追加する
  def crawl_from_twitter_api(req_num)
    crawler = Crawler.new
    tweets  = crawler.get_tweets(req_num)
    crawler.store_tweets_to_db(tweets)
  end
end

# クローラを使いDBにTweetを追加する
# 引数は取得するTweet件数
Main.new.crawl_from_twitter_api(3200)
