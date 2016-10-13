class Method::Tfidf
  # TFを計算する
  # 計算値を単語ごとに記録する
  def self.calc_tf(num_all_words, noun_freq_dic)
    tf_dic = Hash.new(0.0)
    noun_freq_dic.each do |noun|
      tf_dic[noun[0]] = noun[1].to_f / num_all_words.to_f
    end
    tf_dic
  end

  # IDFを計算する
  def self.calc_idf(num_all_docs, num_docs_word_dic)
    idf_dic = Hash.new(0.0)
    num_docs_word_dic.each do |word|
      # idfを計算する
      df = num_all_docs.to_f / word[1].to_f
      idf = Math.log(df)
      # 値を記録
      idf_dic[word[0]] = idf
    end
    idf_dic
  end

  def self.calc_tf_idf(tf_dic, idf_dic)
    tfidf_dic = Hash.new(0.0)
    tf_dic.each_with_index do |word, _idx|
      word_surface = word[0] # 単語の表記
      word_tf      = word[1] # 単語のtf値
      word_idf = idf_dic[word_surface] # 単語のidf値

      # 単語のidf値が計算されていない場合は無視
      next if word_idf == 0.0

      # tf*idf値の計算
      tfidf_dic[word_surface] = word_tf * word_idf
    end
    tfidf_dic
  end

  def self.extract_feature_word(tfidf_dic, num_tweets_of_one_set, overlap_point=1.0)
    sorted_tfidf_dic = {}
    tfidf_dic.each_with_index do |tf_idf, idx|
      # 期間数を計算(表示用)
      begin_ctr = num_tweets_of_one_set * overlap_point * idx 
      end_ctr   = begin_ctr + num_tweets_of_one_set
      # 値でソートする(降順)
      sorted_tfidf_dic = tf_idf.sort_by { |_k, v| v }.reverse.take(10)
      puts "----------- doc #{begin_ctr} ~ #{end_ctr} -----------"
      puts sorted_tfidf_dic
    end
  end
end
