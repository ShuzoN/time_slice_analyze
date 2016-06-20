require './model' # User, Tweet classの定義
require 'active_record'
require 'natto'

# p Tweet.where(user_id:1).select(:text)

user_id = 1
tweets = Tweet.where(user_id: user_id).pluck(:text).to_s


nouns=Array.new
mecab = Natto::MeCab.new
i=0

mecab.parse(tweets) do |n|
  nounFeature = n.feature.split(",")
  hinshi = nounFeature[0].to_sym
  hinshi_detail = nounFeature[1].to_sym

  meishi="名詞".to_sym
  next unless hinshi.equal? meishi

  puts i if i%1000==0
  nouns.push "#{n.surface} #{hinshi} #{hinshi_detail}"
  i=i+1
end

  puts nouns.size
  # File.write 'hoge.txt', nouns.

