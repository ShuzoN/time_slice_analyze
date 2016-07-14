class Document::Document
  attr_accessor :org_txt \
    , :wakati_org_txt \
    , :num_of_all_words

  @@mecab = Natto::MeCab.new(dicdir: "/usr/local/Cellar/mecab/0.996/lib/mecab/dic/mecab-ipadic-neologd")
  # 絵文字の辞書
  @@emoji = Dic::Emoji.new
  # ひらがなのUnicodeコードポイント
  @@hiragana = ("3040".to_i(16).."309F".to_i(16)).to_a

  def initialize(org_t = "")
    @org_txt = org_t              # 原文
    @wakati_org_txt = ""          # 分かち書き文
    @num_of_all_words = 0         # 文書中の全単語数
    @result_morpho_analysis # 形態素解析の結果
    unless org_t == ""
      count_all_words
      # create_wakati
    end
  end

  # urlを削除する
  def self.delete_url(str)
    url = URI.extract(str, ["http"])
    url.concat URI.extract(str, ["https"])
    url.uniq!

    url.each do |u|
      str.delete! u
    end
    str
  end

  # 一文字のひらがなを検出する
  def detect_one_char_hiragana(word)
    w_cp = word.unpack("U*")
    return nil if w_cp.size > 1
    @@hiragana.include?(w_cp[0])
  end

  private

  # 文書中の全単語数を計算
  def count_all_words
    @num_of_all_words = @org_txt.tr("<div_mark>", "").size
  end

  # 分かち書き文を生成
  def create_wakati
    return unless @wakati_org_txt == ""
    @@mecab.parse(org_txt) do |word|
      # 分かち書きをする
      @wakati_org_txt << word.surface << " "
    end
  end
end
