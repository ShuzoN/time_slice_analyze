class Document::UnitDocument < Document::Document

  attr_accessor :nouns_frequency_dic

  def initialize(org_t="")
    # この文書中に含まれる単語の出現頻度を単語ごとに記録
    @nouns_frequency_dic=Hash.new #{:noun => frequency_in_doc}
    super(org_t)
  end

end
