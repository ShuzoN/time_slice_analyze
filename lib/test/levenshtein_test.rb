require "bundler"
Bundler.require
require "nkf"

class LevenshteinDistance
  
  def initialize
    @mecab = Natto::MeCab.new(dicdir: "/usr/local/Cellar/mecab/0.996/lib/mecab/dic/mecab-ipadic-neologd")

  end

  # 文字列配列に対して, 
  # レーベンシュタイン距離を求める
  def test
    str = ["大阪市長選挙","大阪ダブル選挙","市岡中学校","大阪府知事選挙","吉村洋文","期日前投票","ひろふみ","選挙結果","法定","拡散希望"]

    # calc_distance(str)
    absorption_hiragana(str[6])
  end

  def to_katakana(str)
    NKF.nkf('-w -h2 --katakana', str)
  end

  def absorption_hiragana(str)

    @mecab.parse(str) do |word|
      p word.surface
      p word.feature.split(/,/)[7]
    end

    puts to_katakana(str)

  end

  # 文字列配列の全要素に対して, 
  # レーベンシュタイン距離を求める
  # レーベンシュタイン距離 > 0 の場合のみ表示
  def calc_distance(words=[])
    return if words==[]

    words.each_with_index do |w1, idx|
      words.drop(idx).each_with_index do |w2, jdx|
        jdx += idx
        next if jdx == idx

        distance = Levenshtein.normalized_distance(w1, w2)

        if distance != 1
          puts "#{w1} : #{w2}\n score : #{distance}"
        end
      end
    end

  end
end

LevenshteinDistance.new.test

