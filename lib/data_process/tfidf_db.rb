
require "bundler"
Bundler.require
require "leveldb"

module DataProcess
  # {単語=>{区間=>tfidf値}でtfidf値を記録するDB
  class TfidfDB
    # ユーザ名に合わせたKVSDBの作成
    def initialize(username: "", interval: 0)
      # 引数の型チェック
      raise ArgumentError if !username.is_a?(String)  || username.empty?
      raise ArgumentError if !interval.is_a?(Integer) || interval.zero?
      @username = username
      @interval = interval
      dbpath = "./tmp/" + username + "_" + interval.to_s
      @db = LevelDB::DB.new(dbpath)
    rescue ArgumentError => e
      puts e.inspect
      puts $@
      exit 1
    end

    # dbにKey:string => Value:Hashの形で記録する
    # leveldbは, 文字列のみ記録可能
    # hashを文字列に変換して記録する
    def put(key, interval_value)
      raise ArgumentError unless key.is_a?(String)
      raise ArgumentError unless interval_value.is_a?(Hash)
      @db[key] = interval_value.to_s
    rescue ArgumentError => e
      puts e.inspect
      puts $@
      exit 1
    end

    # dbからKeyに対応するvalueを取得
    # 文字列からHashを復元する
    # 戻り値 : Hash
    def get(key)
      raise ArgumentError unless key.is_a?(String)
      # dbから値の取得
      result_value = @db[key]
      raise KeyError unless result_value

      # dbから受け取ったデータをString -> Hash変換
      result_hash = eval(result_value)
      raise TypeError unless result_hash.is_a?(Hash)

      return result_hash
    rescue ArgumentError => e
      puts e.inspect
      puts $@
      exit 1
    end

    def delete(key)
      raise ArgumentError unless key.is_a?(String)
      @db.delete(key)
    rescue ArgumentError => e
      puts e.inspect
      puts $@
      exit 1
    end

    def keys
      @db.map { |k, _| k.force_encoding("utf-8") }
    end

    def values
      @db.values
    end

    # csvファイルからKVSにTFIDFデータを記録する
    # {単語=>{区間=>tfidf}}
    # {"党大会"=>{"0:100"=>0.000234, "100:200"=>0.000452}, ...}
    def store_db_from_csv(filename)
      conv_csv_tfidf = DataProcess::ConvCsvToTfidf.new
      # csvを読み込み
      tfidf_csv = conv_csv_tfidf.read_csv(filename)
      # 区間ごとに区切る
      seperated_interval = conv_csv_tfidf.cut_interval(tfidf_csv)

      # 全区間の全単語を取得
      all_words = conv_csv_tfidf.words(seperated_interval)

      # {単語=>{区間=>tfidf}}の形でデータを整形
      words_separated_interval = {}
      all_words.flatten.uniq.each do |word|
        interval_tfidf = conv_csv_tfidf.value_assoc(word, seperated_interval).to_h
        words_separated_interval.store(word, interval_tfidf)
      end

      # KVSに{単語=>{区間=>tfidf}}の形でデータを保存
      words_separated_interval.each do |key, interval_value|
        put(key, interval_value)
      end
    end
  end
end

# usage
# filename = "tmp/tfidf_result_hashimoto_100.csv"
# d = DataProcess::TfidfDB.new(username: "hashimoto", interval: 100)
# d.store_db_from_csv(filename)

