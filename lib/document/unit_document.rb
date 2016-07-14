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
      posid   = word.posid
      surface = word.surface

      # 特定の名詞のみを対象(一般, 固有名詞)
      next unless (41..47) === posid || 38 == word.posid
      # 半角英数の除去(全角 -> 半角英数変換)
      next if NKF.nkf("-m0Z1 -W -w", surface) =~ /\w/
      # 絵文字の除去
      utf_code = Dic::Emoji.convert_utf_code(surface)
      next if @@emoji.dic.include?(utf_code)
      @nouns_frequency_dic[surface.to_sym] += 1
    end
  end
end
