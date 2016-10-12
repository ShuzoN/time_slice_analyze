require "bundler"
Bundler.require
require "uri"
require "nkf"

class Main
  def initialize
    @crawler = TwitterConnection::Crawler.new
    @g_doc_by_count = Document::Generate::ByCount.new
  end

  def main
    before = Time.now()
    # 要求件数毎にTweetをまとめた文書群を生成する
    # 引数 : (ユーザID, 文書に含めるTweet数)
    whole_doc = @g_doc_by_count.generate_documents(5, 100)

    # idf値を計算する
    num_all_docs = whole_doc.num_all_documents
    num_docs_word_dic = whole_doc.num_of_docs_contain_word_dic

    idf_dic = \
      Method::Tfidf.calc_idf(num_all_docs, num_docs_word_dic)

    # tf値を計算する
    documents_tf = []
    whole_doc.documents.each_with_index do |doc, idx|
      documents_tf[idx] = \
        Method::Tfidf.calc_tf(doc.num_all_words, doc.nouns_frequency_dic)
    end

    # tfidf値を計算する
    tfidf_dic = []
    documents_tf.each_with_index do |tf_dic, idx|
      tfidf_dic[idx] = Method::Tfidf.calc_tf_idf(tf_dic, idf_dic)
    end
    # 文書ごとに特徴語を抽出する
    Method::Tfidf.extract_feature_word(tfidf_dic)
    puts Time.now()-before
  end

# ----------------------------------------
# private

def self.acquire_tweets_and_store_db
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
