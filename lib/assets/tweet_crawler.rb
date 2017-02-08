def acquire_tweets_and_store_db
  # TwitterAPIから1ユーザのtweetを指定件数 取得
  # lib/twitter_connection/connnecter.rb内でユーザの指定を行うようになってます.
  # 使いづらくてすみません
  crawler = TwitterConnection::Crawler.new
  # 取得投稿数上限
  limit = 3200
  tweets = crawler.get_tweets(limit)

  # DBに取得データを保存
  user = tweets.first["user"]
  User.store_db(user)
  Tweet.store_db(tweets)
end

# クローラを使いDBにTweetを追加する
# 引数は取得するTweet件数
acquire_tweets_and_store_db
