
filename = "tmp/tfidf_result_hashimoto_100.csv"
conv_tfidf = DataProcess::ConvCsvToTfidf.new
tfidf_result = conv_tfidf.read_csv(filename)
seperated_interval = conv_tfidf.cut_interval(tfidf_result)

all_words = conv_tfidf.words(seperated_interval)

keywords = {}
all_words.flatten.uniq.each do |word|
  interval_tfidf = conv_tfidf.value_assoc(word, seperated_interval).to_h
  keywords.store(word, interval_tfidf)
end

db = DataProcess::TfidfDB.new(username:"testdb",interval:100)

keywords.each do |key, value|
  db.put(key, value)
end

# p db.keys
p db.get("党大会").keys
p db.get("党大会").values



