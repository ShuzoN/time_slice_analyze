
class Method::SmaTfidf
  # simple moving average tfidf
  def sma_tfidf
    filenames = ["tmp/tfidf_result_hashimoto_100.csv"]
    tfidfdbs = DataProcess::TfidfDbs.new("hashimoto", 100, filenames)
    # tfidfdbs.dbs.each do |name, db|
    #   p name
    #   p db.keys
    #   puts "-----------------------------------------------------"
    #   p db.allwords
    # end
  end
end

Method::SmaTfidf.new.sma_tfidf
