
require './model' # User, Tweet classの定義
require 'active_record'
require 'natto'
require 'uri'

# ==== 指定したユーザのツイートをDBから取得 ====
user_id = 12
tweets  = Tweet.where(user_id: user_id).pluck(:text).to_s
userName= User.where(id: user_id).pluck(:name)[0]
total_noun_count = 0
puts "userName : " + userName

nouns=Hash.new
mecab = Natto::MeCab.new(dicdir:"/usr/local/Cellar/mecab/0.996/lib/mecab/dic/mecab-ipadic-neologd")
nouns_str=""
i=0

# ==== URL除去 ====
def deleteURL(str) #String
  url = URI.extract(str,["http"])
  url.concat URI.extract(str,["https"])

  puts "delete url"
  url.each do |u|
    str.delete! u
  end

  str
end


# 指定した品詞の単語を抽出
def extractPartOfSpeech(n,type, category,words) #partOfSpeech:品詞, category:品詞の詳細
  hinshi = n.feature[0..1].to_sym
  targetHinshi =type.to_sym

  return unless hinshi.equal? targetHinshi

  if n.surface.ascii_only? #アルファベットの除去
    puts n.surface
    return 
  end
  
  return if words.key?(n.surface.to_sym) 
  hinshi_detail= n.feature.split(",")[1].to_sym
  
  return unless hinshi_detail.match /#{category}/
  words.store n.surface.to_sym, "#{hinshi} #{hinshi_detail}".to_sym
  words_str="" unless words_str
  words_str << "#{n.surface.to_s} #{hinshi.to_s} "+hinshi_detail.to_s+"\n"
end

tweets = deleteURL(tweets)

# 名詞を抽出
puts "mecab"
exit 0 if tweets==nil && tweets.size==0
i=0

mecab.parse(tweets) do |n|
  words_str = extractPartOfSpeech(n,"名詞", "一般|固有名詞|サ変接続", nouns)
  i+=1
  break if i!=0 && i/1000==1
end

puts words_str

#==== ファイル書き出し ====
# puts "file write" 
# docdir="docs_make_from_user_tweets"
# time = Time.now.to_s.gsub(" ","_")
# File.write "./#{docdir}/#{userName}_#{time}.txt", words_str
