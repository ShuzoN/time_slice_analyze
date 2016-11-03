
class Method::SmaTfidf
  # simple moving average tfidf
  def sma_tfidf
    filenames = ["tmp/tfidf_result_hashimoto_100.csv"]
    tfidfdbs = Method::TfidfDBs.new("hashimoto", 100, filenames)
    # tfidfdbs.dbs.each do |name, db|
    #   p name
    #   p db.keys
    #   puts "-----------------------------------------------------"
    #   p db.allwords
    # end
  end
end

# 複数の区間別tfidfDBを持ち
# それらを操作するためのクラス
class Method::TfidfDBs
  attr_reader :dbs
  # tfidfDBの初期化
  def initialize(username, interval, filenames)
    raise ArgumentError if !username.is_a?(String)  || username.empty?
    raise ArgumentError if !interval.is_a?(Integer) || interval.zero?
    raise ArgumentError if !filenames.is_a?(Array)  || filenames.empty?
    @dbs = nil
    @dbs = make_db_each_doc(username, interval, filenames)
  end

  # あるユーザに関して区間別にtfidfデータベースを作成
  def make_db_each_doc(username, interval, filenames)
    dbs = {}
    filenames.each do |f_name|
      d = DataProcess::TfidfDB.new(username: username, interval: interval)
      d.store_db_from_csv(f_name)
      db_name = username + "_" + interval.to_s
      dbs.store(db_name, d)
    end
    return dbs
  rescue ArgumentError => e
    puts e.inspect
    puts $ERROR_POSITION
    exit 1
  end

  # あるユーザに関するtfidfDBから任意の区間のDBを検索
  def search_db(username, interval)
    raise NameError if @dbs.nil? || @dbs.empty?
    db_name = username + "_" + interval.to_s
    return @dbs[db_name]
  rescue ArgumentError => e
    puts e.inspect
    puts $ERROR_POSITION
    exit 1
  end
end

Method::SmaTfidf.new.sma_tfidf
