require 'pathname'

# csvファイルを読み込んで, 文字列を返す
def read_csv(filename)
  begin
    # 引数で渡されたファイルパスを基に
    # ファイルオープン
    csv_filepath = "#{filename}"
    raise ArgumentError if !filename.kind_of?(String)
    f_path = Pathname.new(csv_filepath)
    raise IOError, "file not exist. enter filepath : #{f_path}" unless f_path.cleanpath.file?

    # CSVがUTF-16で保存されているのでUTF8に変換
    f = File.open(f_path,'r:UTF-16LE:UTF-8')
    content = f.read()
    f.close
    return content
  rescue => e
    puts e.inspect; puts $@; exit 1
  end
end

# 区間ごとの内容を切り出す
# Key: 区間 , Value : 単語=>tfidfのhash
def cut_interval(content)
    csv_content = content
    raise ArgumentError if !content.kind_of?(String)

    separeted_details = csv_content.split(/(\d{1,4}:\d{1,4})/).rotate

    interval_words_tfidf={}
    separeted_details.each_slice(2) do |range, values|
      break if !range.kind_of?(String) || !values.kind_of?(String)
      word_tfidf = values.scan(/,([^,.]*),(\d.\d+)\n/).to_h
      interval_words_tfidf.store(range, word_tfidf)
    end
    return interval_words_tfidf
end

# 単語が含まれている区間を検索する
def included_interval(keyword, seperated_interval)
  intervals = []
  seperated_interval.each do |interval, words|
    intervals << interval if words.has_key?(keyword)
  end
  return intervals
end


# 単語が含まれている区間を検索し, 
# 区間とtfidf値の対で取得する
# [[区間1, tfidf値],[区間2, tfidf値],...]
def value_assoc(keyword, seperated_interval)
  resultset= []
  seperated_interval.each do |interval, words|
    if words.has_key?(keyword)
      tfidf = words[keyword]
      resultset.push([interval, tfidf]) 
    end
  end
  return resultset
end

filename = "tmp/tfidf_result_hashimoto_100.csv"
tfidf_result = read_csv(filename)
seperated_interval = cut_interval(tfidf_result)
p included_interval("党大会", seperated_interval)
p value_assoc("党大会", seperated_interval)
