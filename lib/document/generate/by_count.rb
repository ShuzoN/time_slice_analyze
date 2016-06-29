class Document::Generate::ByCount 

  def initialize
  end

  # 要求された件数のTweetをまとめた文書を複数個作る
  # 要求が100件であれば,3200/100=32個文書を生成する
  def generate_documents(user_id, request_count)
    # 生成されるドキュメント数
    division_count = Tweet.find_by_user(user_id).count / request_count

    whole_document = Document::WholeDocument.new()
    division_count.times do |div_times|
      # 既に取得した分の埋め合わせ
      offset   = request_count * div_times 
      # 生成された文書を記録
      doc = generate_one_document(user_id, request_count ,offset)
      document = Document::UnitDocument.new(doc)

      # 文書群に登録
      whole_document.documents[div_times] = document
    end
    return whole_document
  end


  # 件数分のTweetをまとめた文書を1つ生成する
  def generate_one_document(user_id, request_count, offset)
    tweets_group = Tweet.group_by_count(user_id, request_count, offset)
    return  Tweet.to_d(tweets_group)
  end

end
