require './model' # User, Tweet classの定義
require 'active_record'
require 'natto'
require 'uri'

# --tweetの平均長を計算

user_id = 12
# (13).each do |user_id|
tweets  = Tweet.where(user_id: user_id).pluck(:text)
userName= User.where(id: user_id).pluck(:name)[0]
mecab = Natto::MeCab.new(dicdir:"/usr/local/Cellar/mecab/0.996/lib/mecab/dic/mecab-ipadic-neologd")
docdir="/aveNumOfWords"
file = File.open ".#{docdir}/#{userName}_aveNumOfWords.txt","w"

numOfWords  = 0             #ツイート内の単語数
numOfTweet  = tweets.size   #ツイートの総数

def deleteURL(tweet)
  url = URI.extract(tweet,["http"])
  url.concat URI.extract(tweet,["https"])
  url.uniq!

  url.each do |u|
    tweet.delete! u
  end
  tweet
end


tweets.each do |tweet|
  tweet = deleteURL(tweet)
  counter=0

  next if tweet.size==0
  mecab.parse(tweet) do |n|
    next if n.feature[0..1]=~ /記号|BO/

    # puts n.surface + " " + n.feature[0..1]
    counter+=1
  end
  
  numOfWords+=counter
end

aveNumOfWords = numOfWords/numOfTweet


#==== ファイル書き出し ====
time = Time.now.to_s.gsub(" ","")
file.write <<EOS
 ユーザ名\t#{userName}
 総単語数\t#{numOfWords}
 総tweet数\t#{numOfTweet}
 平均単語数\t#{aveNumOfWords}

 -----------------------------
EOS

puts user_id
# end
file.close
