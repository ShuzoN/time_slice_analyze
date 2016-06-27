require 'bundler'
Bundler.require

class Main 

  def initialize
    @crawler = TwitterConnection::Crawler.new
  end

  def main
    g_doc_by_count = Document::Generate::ByCount.new
    documents = g_doc_by_count.generate_documents(3,100) #user_id, req_num
  end

  # ----------------------------------------
  private

  def acquire_tweets_and_store_db
    # TwitterAPIから1ユーザのtweetを指定件数 取得
    tweets = @crawler.get_tweets(3200)

    # DBに取得データを保存
    user = tweets.first["user"]
    User.store_db(user)
    Tweet.store_db(tweets)
  end
end

# クローラを使いDBにTweetを追加する
# 引数は取得するTweet件数
Main.new.main
