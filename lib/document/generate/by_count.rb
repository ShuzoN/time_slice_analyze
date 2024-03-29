require "parallel"
require "thread"
class Document::Generate::ByCount

  def initialize
  end

  # 要求された件数のTweetをまとめた文書を複数個作る
  # 要求が100件であれば,3200/100=32個文書を生成する
  def generate_documents(user_id, request_count, overlap_point=1.0)
    # 生成されるドキュメント数
    division_count = Tweet.find_by_user(user_id).count / request_count

    # 分割数 = 独立区間 / 重複区間の割合
    division_count = (division_count / (1.0/overlap_point.to_f)).to_i

    whole_document = Document::WholeDocument.new
    locker = Mutex::new

    # 並行処理
    # n件のTweetをまとめた文書を生成し,
    # 生成した文書を1つの全文書オブジェクトにまとめる
    division_count.times do |div_times|
      # 既に取得した分の埋め合わせ
      offset = ((request_count * (1.0/overlap_point.to_f)) * div_times).to_i

      # n件のTweetをまとめた文書を生成
      doc = generate_one_document(user_id, request_count, offset)
      doc_rm_url = Document::Document.delete_url(doc)
      document = Document::UnitDocument.new(doc_rm_url)

      next unless document.org_txt != ""
      # 文書中に含まれる単語の出現頻度を単語ごとに記録
      document.count_nouns_frequency
      # 文書群に登録
      locker.synchronize do
        # このブロック内は必ず同時に一つのスレッドしか処理しない
        whole_document.documents[div_times] = document
      end
    end

    # Tweetから取り出された名詞を全部ファイルに書き出す
    f = File.open("./tmp/noun.txt", "w")
    noun = []
    docs = whole_document.documents
    docs.each do |doc|
      noun << doc.nouns_frequency_dic.keys
    end
    f.write(noun.flatten.join("\n"))
    f.close


    # 全単語について出現する文書数を数える
    whole_document.count_num_docs_contains_word
    # 生成された文書数を数える
    whole_document.count_num_all_documents
    whole_document
  end

  # 件数分のTweetをまとめた文書を1つ生成する
  def generate_one_document(user_id, request_count, offset)
    tweets_group = Tweet.group_by_count(user_id, request_count, offset)
    Tweet.to_d(tweets_group)
  end

end
