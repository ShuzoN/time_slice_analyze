require "bundler"
Bundler.require
require "csv"

@mecab = Natto::MeCab.new(dicdir: "/usr/local/Cellar/mecab/0.996/lib/mecab/dic/mecab-ipadic-neologd")
word_counter = {}
user_id = 5
@doc = Document::Document.new

limit=300
of=0
c = (0..32).map{|idx|
  of = idx * limit
  month_noun_count = 0
  tws=Tweet.where(user_id: user_id).offset(of).limit(limit)
  tws.each{|tw|
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
  }
  [of,month_noun_count]
}

c.each{|f| p "#{f[0]} #{f[1]}"}


