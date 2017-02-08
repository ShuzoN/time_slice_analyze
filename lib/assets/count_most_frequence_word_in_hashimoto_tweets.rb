require "bundler"
Bundler.require

@mecab = Natto::MeCab.new(dicdir: "/usr/local/Cellar/mecab/0.996/lib/mecab/dic/mecab-ipadic-neologd")
word_counter = {}
user_id = 5

Tweet.where(user_id: user_id).each do |tw|
  text = tw.text
  @mecab.enum_parse(tw.text).each do |word|
    surface = word.surface
    f = word.feature.split(/,/)
    if f[0]=="名詞" && f[1]=~/一般|固有名詞/
      next if surface =~/\w/
      if word_counter.key?(surface)
        c = word_counter[surface] + text.count(surface)
        word_counter.store(surface, c)
      else
        word_counter.store(surface, text.count(surface))
      end
    end
  end
end

rank_limit = 30
result =  Hash[ word_counter.sort_by{ |_, v| -v } ].to_a[0..rank_limit]

result.each do |r|
  puts r[0] + ":" + r[1].to_s
end
