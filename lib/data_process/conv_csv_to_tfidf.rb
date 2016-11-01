require "pathname"

module DataProcess
  # csvファイルを読み込んで, 文字列を返す
  class ConvCsvToTfidf
    def read_csv(filename)
      # 引数で渡されたファイルパスを基に
      # ファイルオープン
      csv_filepath = filename.to_s
      raise ArgumentError unless filename.is_a?(String)
      f_path = Pathname.new(csv_filepath)
      raise IOError, "file not exist. enter filepath : #{f_path}" unless f_path.cleanpath.file?

      # CSVがUTF-16で保存されているのでUTF8に変換
      f = File.open(f_path, "r:UTF-16LE:UTF-8")
      content = f.read
      f.close
      return content
    rescue => e
      puts e.inspect
      puts $@
      exit 1
    end

    # 区間ごとの内容を切り出す
    # 区間=>{単語=>tfidf}という2段組のHashを生成する
    def cut_interval(content)
      csv_content = content
      raise ArgumentError unless content.is_a?(String)

      # 区間ごとにcsvを切り出す
      # ["0:100", ",ゼミ,0.014461107650\n,メルマガ,0.0124740051308\n,..."]
      separeted_interval = csv_content.split(/(\d{1,4}:\d{1,4})/)
      raise RangeError unless separeted_interval.delete_at(0) # BOM削除

      # 区間と単語群(表記,tfidf値)からなる配列から
      # 区間=>{単語=>tfidf}という2段組のHashを生成する
      interval_words_tfidf = {}
      separeted_interval.each_slice(2) do |range, values|
        if !range.is_a?(String) || !values.is_a?(String)
          raise StopIteration, \
                "<key: #{range}, #{range.class} >, <value: #{values}, #{values.class}>"
        end
        word_tfidf = values.scan(/,([^,.]*),(\d.\d+)\n/).to_h
        interval_words_tfidf.store(range, word_tfidf)
      end
      return interval_words_tfidf

    rescue => e
      puts e.inspect
      puts $@
      exit 1
    end

    # 単語が含まれている区間を検索する
    def included_interval(keyword, seperated_interval)
      intervals = []
      seperated_interval.each do |interval, words|
        intervals << interval if words.key?(keyword)
      end
      return intervals
    end

    # CSVに含まれる全単語を返す
    # 区間ごとに区切る
    # [[a1,b1,c1,...],[a2,b2,c2,...]]
    def words(seperated_interval)
      words = seperated_interval.map do |interval, intv_words|
        intv_words.keys
      end
      return words
    end

    # 単語が含まれている区間を検索し,
    # 区間とtfidf値の対を返す
    # [[区間1, tfidf値],[区間2, tfidf値],...]
    def value_assoc(keyword, seperated_interval)
      resultset = []
      seperated_interval.each do |interval, words|
        if words.key?(keyword)
          tfidf = words[keyword]
          resultset.push([interval, tfidf])
        end
      end
      return resultset
    end
  end
end

  # usage
  # filename = "tmp/tfidf_result_hashimoto_100.csv"
  # conv_tfidf = ConvCsvToTfidf.new
  # tfidf_result = conv_tfidf.read_csv(filename)
  # seperated_interval = conv_tfidf.cut_interval(tfidf_result)
  # p conv_tfidf.included_interval("メルマガ", seperated_interval)
  # p conv_tfidf.value_assoc("メルマガ", seperated_interval)
