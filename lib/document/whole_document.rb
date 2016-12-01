class Document::WholeDocument < Document::Document
  attr_accessor :num_of_docs_contain_word_dic, :documents, :num_all_documents, :num_of_word_freq_all_doc


  def initialize
    # 複数の文書をもつ文書群
    @documents = [] #=>Document::UnitDocument.obj
    # 生成された文書の総数
    @num_all_documents = 0
    # ある単語が出現する文書数を単語ごとに記録
    @num_of_docs_contain_word_dic = Hash.new(0) # {:word=> num_docs}
    # 全文書における単語の出現回数
    @num_of_word_freq_all_doc = Hash.new(0) # {:word=> freq_in_all_docs}
  end

  # 全単語について出現する文書数を数える
  def count_num_docs_contains_word
    @documents.each do |document|
      # 文書に含まれる名詞を取得
      nouns_dic = document.nouns_frequency_dic.keys.uniq
      nouns_dic.each do |noun|
        @num_of_docs_contain_word_dic[noun] += 1
      end
    end
    file = File.open("./tmp/num_docs_contain_word.txt", "w+")
    file.write(@num_of_docs_contain_word_dic)
  end

  # 生成された文書数を数える
  def count_num_all_documents
    num_docs = @documents.size
    return nil if  num_docs == 0
    @num_all_documents = num_docs
  end

  # 各単語について総出現回数を数える
  def count_freq_each_word_in_all_doc
    @documents.each do |doc|
      doc.nouns_frequency_dic.each do |word, freq|
        tmp_freq = @num_of_word_freq_all_doc[word] + freq
        @num_of_word_freq_all_doc.store(word, tmp_freq)
      end
    end
    return @num_of_word_freq_all_doc
  end
end
