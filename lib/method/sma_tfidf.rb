
class Method::SmaTfidf
  # simple moving average tfidf
  def sma_tfidf
    filenames = ["tmp/tfidf_result_hashimoto_100.csv"]
    tfidfdb = DataProcess::TfidfDB.new(username: "hashimoto", interval: 100)
    tfidfdb.store_db_from_csv(filenames[0])
    tfidfdb.allwords.each do |interval_words|
      interval_words.each do |word|
        interval_containging_word = tfidfdb.get(word)
        continue_intervals = continuous?(interval_containging_word, 3)
        p word, continue_intervals if continue_intervals
      end
    end
  end

  def continuous?(interval_containging_word, slice_size)
    raise ArgumentError, interval_containging_word unless interval_containging_word.is_a?(Hash)
    raise ArgumentError, slice_size unless slice_size.is_a?(Integer)

    return nil if interval_containging_word.size == 1

    previous = ""             # 前区間(ex. 2700:2800)
    previous_tail = ""        # 前区間の末尾(ex. 2700:2800の2800)
    continous_intervals = []  # 連続区間をまとまりごとに格納する2次配列
    interval_chunk = []       # 連続区間

    # 単語ごとに連続区間を見つける
    interval_containging_word.keys.each do |interval|
      # 現区間(2700:2800なら2700を保持)
      current = interval[/(\d{,4}):(\d{,4})/, 1]

      if current == previous_tail
        interval_chunk << previous if interval_chunk.empty?
        interval_chunk << interval
      end
      previous = interval
      previous_tail = interval[/(\d{,4}):(\d{,4})/, 2]

      if interval_chunk.size == slice_size
        continous_intervals.push(interval_chunk)
        interval_chunk = []
      end
    end
    return nil if continous_intervals.empty?
    return continous_intervals
  rescue StandardError => e
    puts e.inspect
    puts $ERROR_POSITION
    exit 1
  end
end

Method::SmaTfidf.new.sma_tfidf
