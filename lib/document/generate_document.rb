class Document::GenerateDocument < Document::Document

  attr_reader :documents

  def initialize
    @previous_tweet_id = 0
    @documents=Hash.new(times:0, content:[])
    @division_mark = "<div_mark>" # Tweetの区切り
  end

  # 要求された件数のTweetをまとめた文書を作る
  #
  def generate_by_count(user_id, request_count)

    # 生成されるドキュメント数
    division_count = Tweet.find_by_user(user_id).count / request_count

    division_count.times do |div_times|

      # 既に取得した件数分の埋め合わせ
      offset = request_count * div_times


      content = Tweet.group_by_count(user_id, request_count, offset) \
                  .pluck(:text).join(@division_mark)
      
      @documents.store(div_times, content) 
    end
  end
end
