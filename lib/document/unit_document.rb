class Document::UnitDocument < Document::Document
  attr_accessor :nouns_frequency_dic, :num_all_words

  def initialize(org_t = "")
    # この文書中に含まれる単語の出現頻度を単語ごとに記録
    @nouns_frequency_dic = Hash.new(0) # {:noun => frequency_in_doc}
    @num_all_words = 0
    super(org_t)
  end

  # 文書中に含まれる名詞の出現頻度を名詞ごとに記録
  def count_nouns_frequency
    @@mecab.parse(org_txt) do |word|
      @num_all_words += 1
      next unless (41..47) === word.posid || 38 == word.posid
      next if word.surface =~ /\w/
      @nouns_frequency_dic[word.surface.to_sym] += 1
    end
  end
end
