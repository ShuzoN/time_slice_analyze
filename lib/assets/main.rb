require 'bundler'
Bundler.require

class Main 

  def initialize
    @crawler = TwitterConnection::Crawler.new
    @g_doc_by_count = Document::Generate::ByCount.new
  end

  def main
    # 要求件数毎にTweetをまとめた文書群を生成する
    # 引数 : (ユーザID, 文書に含めるTweet数)
    whole_documents = @g_doc_by_count.generate_documents(3,100) 
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
