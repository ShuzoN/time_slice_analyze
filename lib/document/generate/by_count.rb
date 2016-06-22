class Document::Generate::ByCount < Document::Document

  attr_reader :documents

  def initialize
    @documents=Hash.new(times:0, content:[]) # 生成された文書
  end

  # 要求された件数のTweetをまとめた文書を複数個作る
  def generate_documents(user_id, request_count)
    # 生成されるドキュメント数
    division_count = Tweet.find_by_user(user_id).count / request_count

    division_count.times do |div_times|
      offset  = request_count * div_times # 既に取得した分の埋め合わせ
      content = generate_document(user_id, request_count ,offset)
      @documents.store(div_times, content) 
    end
  end

  # 件数分のTweetをまとめた文書を1つ生成する
  def generate_document(user_id, request_count, offset)
    tweets_group = Tweet.group_by_count(user_id, request_count, offset)
    return  Document::Document.to_d(tweets_group)
  end

end
