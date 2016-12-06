require "bundler"
Bundler.require
require "uri"
require "nkf"
require "csv"

class Main

  USER_ID = 5
  NUM_TWEETS_OF_ONE_SET = 100

  def initialize
    @crawler = TwitterConnection::Crawler.new
    @g_doc_by_count = Document::Generate::ByCount.new
  end

  def main
    overlap = 1
    argv = ARGV.dup

    if idx = argv.index("--overlap") 
      idx = idx.next
      raise "please enter overlap point in number" if argv[idx].nil?
      ol = argv[idx][/\d/]
      raise "please enter overlap point bigger than 0" unless ol.to_i > 0
      overlap = ol.to_i
    end

    msg = "please choose mode by command line | -t(tfidf) or -e(entropy)"
    raise msg unless ARGV.grep(/-tfidf|-entropy/)

    if argv.index("--ttidf")
      tfidf(overlap)
    elsif argv.index("--entropy")
      entropy(overlap, 6)
    end

  rescue => e
    puts e.inspect
    puts $ERROR_POSITION
  end

  # tfエントロピーを計算し, 
  # 複数区間に渡って頻出する単語を抽出する
  def entropy(overlap, continuous_appear_interval)
    puts "<count num of words each document>\n\n"
    # 文書集合を取得
    whole_doc, _, _ = slice_tweets_by_count(overlap)

    puts "<calcurate tf value every words>\n\n"
    # tf値を計算する
    documents_tf = []
    whole_doc.documents.each_with_index do |doc, idx|
      documents_tf[idx] = Method::Tfidf.calc_tf(doc.num_all_words, doc.nouns_frequency_dic)
    end

    puts "<calcurate entropy every words>\n\n"
    # 全単語の総出現回数を数える
    whole_doc.count_freq_each_word_in_all_doc
    # 単語ごとのエントロピー計算
    entropy_each_word = calc_entropy_about_word(whole_doc)

    # 文書ごとに単語のtf・エントロピー値を計算する
    tf_ent_each_doc, tf_ent_allword = tf_entropy(documents_tf, entropy_each_word)
    # 各区間でエントロピーが高い順に単語を取得
    high_entropy_each_doc = []
    high_entropy_allword = []
    tf_ent_each_doc.each do |tfen|
      high_entropy_each_doc << tfen.sort_by{|_,v|-v}[0..10].to_h
      high_entropy_allword << tfen.sort_by{|_,v|-v}[0..10].to_h.keys
    end
    high_entropy_allword.flatten!

    # 3区間以上で出現した単語を返す
    p extract_continuous_word(high_entropy_allword, continuous_appear_interval)
  end

  # 複数区間で連続する単語を抽出する(entropy)
  def extract_continuous_word(allword, num_consecutive_interval)
    continuous_words = Hash.new(0)
    allword.uniq.each do |word|
      count = allword.count(word)
      if count >= num_consecutive_interval
        continuous_words.store(word, count)
      end
    end
    return continuous_words
  end

  # tfエントロピー値を計算する
  def tf_entropy(documents_tf, entropy_each_word)
    # 単語ごとのtfエントロピー値
    tf_entropy_result = []
    # tfエントロピーで抽出された全単語(重複有り)
    tf_ent_allwords = []
    documents_tf.each do |doc_tf|
      # 文書ごとのTF-entropy値
      te = Hash.new(0.0)
      doc_tf.each do |word, tf|
        tf_ent_allwords << word
        te.store(word.to_s, tf*entropy_each_word[word])
      end
      tf_entropy_result << te
    end
    return tf_entropy_result, tf_ent_allwords.flatten
  end

  # 単語ごとにエントロピーを計算する
  def calc_entropy_about_word(whole_doc)
    # 単語ごとのエントロピー
    entropy_each_word = Hash.new(0.0)
    # 全文書における各単語の出現回数
    word_freq_all_doc = whole_doc.num_of_word_freq_all_doc

    # エントロピーの計算
    whole_doc.documents.each do |doc|
      doc.nouns_frequency_dic.each do |word, freq|
        # ある単語について 1文書中の出現回数/ 全文書中の総出現回数
        probability = freq.to_f/word_freq_all_doc[word].to_f
        next if probability.zero?

        # 情報量plog2pを計算し, 加算する
        pre_prob = entropy_each_word[word]
        prob = pre_prob + -1 * probability * Math.log2(probability)
        entropy_each_word.store(word, prob)
      end
    end
    return entropy_each_word
  end

  def slice_tweets_by_count(overlap)
    # 要求件数毎にTweetをまとめた文書群を生成する
    # 引数 : (ユーザID, 文書に含めるTweet数)
    whole_doc = Document::WholeDocument.new
    # 前後の期間と重複させる割合
    # 重複なしは'1'を指定する
    whole_doc = @g_doc_by_count.generate_documents(USER_ID, NUM_TWEETS_OF_ONE_SET, overlap)

    # 総文書数
    num_all_docs = whole_doc.num_all_documents
    # 単語ごとの出現文書数
    num_docs_word_dic = whole_doc.num_of_docs_contain_word_dic

    return whole_doc, num_all_docs, num_docs_word_dic
  end

  def tfidf(overlap)
    whole_doc, num_all_docs, num_docs_word_dic = slice_tweets_by_count(overlap)

    # idf値を計算する
    idf_dic = \
      Method::Tfidf.calc_idf(num_all_docs, num_docs_word_dic)

    # tf値を計算する
    documents_tf = []
    whole_doc.documents.each_with_index do |doc, idx|
      documents_tf[idx] = Method::Tfidf.calc_tf(doc.num_all_words, doc.nouns_frequency_dic)
    end

    # tfidf値を計算する
    tfidf_dic = []
    documents_tf.each_with_index do |tf_dic, idx|
      tfidf_dic[idx] = Method::Tfidf.calc_tf_idf(tf_dic, idf_dic)
    end

    # 文書ごとに特徴語を抽出する
    csv = Method::Tfidf.extract_feature_word(tfidf_dic, NUM_TWEETS_OF_ONE_SET, overlap_point)
    write_csv_of_tfidf(csv, USER_ID , NUM_TWEETS_OF_ONE_SET, overlap_point)

    puts Time.now()-before
  end

  # ----------------------------------------
  # private

  # tfidfの結果をファイルに書き込む
  def write_csv_of_tfidf(csv, userid, num_tweets, overlap)
    # ユーザ名を取得
    user_name = User.find(userid).name
    file_name = "" 

    # 重複区間の有無でファイル名を分岐
    if overlap == 1.0 
      file_name = "./tmp/tfidf_result_#{user_name}_#{num_tweets}.csv"
    elsif
      deno = calc_denominator(overlap)
      return unless deno
      file_name = "./tmp/tfidf_result_#{user_name}_overlap_#{num_tweets}_1_#{deno}.csv"
    end

    if file_name.empty?
      puts "can't export csv."
      return
    end
    # ファイル書き込み
    f = File.open(file_name,'w')
    f.write(csv)
    f.close
  end

  # 重複区間を示す分母を求める
  # (1/2なら2, 1/3なら3を求める)
  def calc_denominator(overlap)
    if !overlap.kind_of?(Numeric) || overlap == 0.0 || overlap < 0.0
      puts "error. overlap is illegal value. <overlap:#{overlap}>"
      return 0
    end
    return 1 if overlap == 1

    # 分母を求める
    init_denominator = 100.0
    pre_deno = 0.0
    over_deno = 1000000.0
    lower_deno = 0.0
    denominator = 0

    denominator = search_denominator(overlap, init_denominator, pre_deno, over_deno, lower_deno)
    return denominator
  end

  # # overlapの分母を探索する
  # 分数に逆数をかけると1になる特性を利用して分母を求める
  # 再帰を利用して2分木で適当に範囲を求め,
  # そのあと, 範囲内を逐次処理して正確な分母を求める

  def search_denominator(overlap, denominator, pre_denominator, over_deno, lower_deno)
    return 1 if overlap == 1

    # 分母(逆数)を検証
    num = overlap * denominator

    # 大体の範囲がわかったら, 逐次処理で値を探す
    if over_deno < 1000000.0 && 0.0 < lower_deno
      (lower_deno.floor..over_deno.ceil).each.with_index do  |den,idx|
        if overlap * den == 1
          denominator = den
          return den
        end
      end

      # 逆数をかけた値が1を超えたら, 逆数を減らす
      # 逆数をかけた値が1に非常に近いとき, 逆数を記録する
    elsif num > 1
      over_deno = denominator if num%1.05 > 1.0 && denominator < over_deno
      pre_denominator = denominator.round
      denominator -= denominator/2
      denominator = search_denominator(overlap, denominator, pre_denominator, over_deno, lower_deno)

      # 逆数をかけた値が1を下回ったら, 逆数を増やす
      # 逆数をかけた値が1に非常に近いとき, 逆数を記録する
    elsif num < 0.99
      lower_deno = denominator if num%0.95 < 0.1 && denominator > lower_deno
      denominator += denominator/2
      denominator = search_denominator(overlap, denominator, pre_denominator, over_deno, lower_deno)
    end
    return denominator
  end

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
