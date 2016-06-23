class Document::Document
  attr_accessor :org_txt \
               ,:wakati_org_txt \
               ,:num_of_all_words

  def initialize
   @org_txt=""            # 原文
   @wakati_org_txt=[]     # 分かち書きした原文
   @num_of_all_words=0    # 文書中の全単語数
  end

end
