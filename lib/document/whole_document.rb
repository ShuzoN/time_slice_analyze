class Document::WholeDocument < Document::Document

  attr_accessor :num_of_docs_contain_noun

  def initialize
    # ある単語が出現する文書数を単語ごとに記録
    @num_of_docs_contain_word_dic=Hash.new #{:word=> num_docs}
    super
  end

end
