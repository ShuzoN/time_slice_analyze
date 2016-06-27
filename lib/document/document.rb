class Document::Document
  attr_accessor :org_txt \
               ,:wakati_org_txt \
               ,:num_of_all_words

  @@mecab = Natto::MeCab.new(dicdir:"/usr/local/Cellar/mecab/0.996/lib/mecab/dic/mecab-ipadic-neologd")

  def initialize(org_t="")
    @org_txt=org_t              # 原文
    @wakati_org_txt=""          # 分かち書き文
    @num_of_all_words=0         # 文書中の全単語数
    @result_morpho_analysis     # 形態素解析の結果
    unless org_t == ""
      count_all_words
      create_wakati
    end
  end

  private 

  # 文書中の全単語数を計算
  def count_all_words
    @num_of_all_words = @org_txt.tr("<div_mark>","").size 
  end

  # 分かち書き文を生成
  def create_wakati
    return unless @wakati_org_txt==""
    extract_word = Proc.new{|word|
      # 分かち書きをする
      @wakati_org_txt << word.surface << " "
    }
    morphological_analysis(){extract_word}
  end

  # 形態素解析
  def morphological_analysis # 引数:Procオブジェクト
    org_txt = @org_txt.tr("<div_mark>"," ") 
    @@mecab.parse(org_txt){|word| 
      yield.call(word)
    }
  end
end
