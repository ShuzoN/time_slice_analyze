class TwitterConnection::Crawler
  # twitter apiと接続するクラス
  @@connecter = TwitterConnection::Connecter.new

  def initialize
    @max_id = nil # 取得時の"最も過去のtweet id"
    @tweets = [] # 取得したtweetのキャッシュ
  end

  # Twitter APIからTweetを取得し配列に整形する
  # APIは1度に200件まで取得可能. 最後は端数を取得.
  # 200件を超える場合は, 最後のTweetIDを記憶して, そこから再取得を行う.
  # 要求件数に到達するまで取得を行う.
  def get_tweets(req_num = 1) # default=1
    if req_num <= 0
      logger.debug "too few request paramater argment!!"
      return
    end

    # 取得回数の計算
    acquire_times, acquire_fraction = calculate_acquire_times(req_num)

    # 200 * t 件取得
    acquire_times.times do |_t|
      store_tweets_to_cache(200, @max_id)
    end

    # 端数を取得
    if acquire_fraction > 0
      fraction = acquire_fraction
      if @max_id
        # 重複する1件を取り除く
        fraction -= (acquire_times - 1)
      end
      store_tweets_to_cache(fraction, @max_id)
    end
    @tweets
  end

  # ----------------- private ---------------------
  #
  private

  # APIからの取得回数と端数を計算
  def calculate_acquire_times(req_num)
    return 0, req_num if req_num < 200

    times    = req_num / 200  # 取得回数(1回200件取得)
    fraction = req_num % 200  # 取得後の端数
    [times, fraction]
  end

  # twitter apiからtweetを取得するメソッド
  # twitter apiから受け取ったjsonを配列に変換
  def get_tweets_from_api(req_num, max_id)
    tweet_json = @@connecter.get_tweets_from_api(req_num, max_id).body
    JSON.parse(tweet_json)
  end

  # リクエスト件数分tweetを取得する
  # max_idパラメタは指定IDのTweet自身も含めて取得する
  # 重複が起きるため, 1引く.
  def store_tweets_to_cache(req_num, max_id)
    tweets = get_tweets_from_api(req_num, max_id)
    @tweets.concat(tweets)

    @max_id = tweets.last["id"].to_i - 1 if tweets.last
  end

  # tweetの情報をDBに加える
  def store_tweets_to_db(tweets)
    tweets.each do |tweet| # tweet.class => hash
      # Tweetテーブルにデータ追加
      Tweet.storeTweet(tweet)
    end
  end
end
