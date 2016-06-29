class Document::WholeDocument < Document::Document

  attr_accessor :num_of_docs_contain_noun, :documents

  def initialize()
    # 複数の文書をもつ文書群
    @documents=[] #=>Document::UnitDocument.obj
    # ある単語が出現する文書数を単語ごとに記録
    @num_of_docs_contain_word_dic=Hash.new #{:word=> num_docs}
  end

  # 単語が出現する文書数を数える
  def count_num_docs_contains_word

  end
end
