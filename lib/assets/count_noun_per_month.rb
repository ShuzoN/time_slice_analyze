require "bundler"
Bundler.require
require "csv"

@mecab = Natto::MeCab.new(dicdir: "/usr/local/Cellar/mecab/0.996/lib/mecab/dic/mecab-ipadic-neologd")
word_counter = {}
user_id = 5
@doc = Document::Document.new

dates=[]
date="2015/4/1".in_time_zone
while(date<"2016/9/1".in_time_zone)
  dates << date
  date = date.next_month
end


p dates.each_cons(2).map.each{|d1,d2| 
  month_noun_count = 0
  Tweet.where(user_id: user_id).where(post_date: d1..d2).each do |tw|
    text = tw.text
    @mecab.enum_parse(tw.text).each do |word|
      surface = word.surface
      f = word.feature.split(/,/)
      if f[0]=="名詞" && f[1]=~/一般|固有名詞/
        @doc.emoji?(surface)
        @doc.latin?(surface)
        @doc.cyrillic?(surface)
        @doc.detect_one_char_hiragana(surface)
        next if surface =~/\w/
         month_noun_count+=1
      end
    end
  end
  month_noun_count
}.to_csv

