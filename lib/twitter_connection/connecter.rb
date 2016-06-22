class TwitterConnection::Connecter

  attr_reader :request_token

  # コンストラクタ
  def initialize() 
    #twitter APIの初期設定
    @request_token = authentication()
    @user_name = "namu_r21"
  end

  # 最新Tweetデータの取得
  def get_tweets_from_api(req_num,max_id)
    url =  "https://api.twitter.com/1.1/statuses/user_timeline.json"
    url += "?screen_name=#{@user_name}&count=#{req_num}"

    if max_id 
      url += "&max_id=#{max_id}"
    end
    @request_token.request(:get, url)
  end

# -----------private method---------------
  private
  # twitter apiに対し認証を行うメソッド
  def authentication
    #twitter APIの初期設定
    consumer_key        = ENV['CONSUMER_KEY_FOR_TWITTER']
    consumer_secret     = ENV['CONSUMER_SECRET_FOR_TWITTER']
    access_token        = ENV['ACCESS_TOKEN_FOR_TWITTER']
    access_token_secret = ENV['ACCESS_TOKEN_SECRET_FOR_TWITTER']
    # コンシューマキー作成
    # コンシューマキー : apiを利用するユーザアプリケーションを特定するキー
    consumer = OAuth::Consumer.new(
      consumer_key, 
      consumer_secret, 
      {
        :site =>'https://api.twitter.com/'
      }
    )
    # アクセストークンの作成
    # アクセストークン : api利用時に利用する時にユーザのid,passの代わりとして認証時に利用されるトークン
    # token = {
    #   :access_token         => access_token,
    #   :access_token_secret  => :header
    # }
    # return OAuth::AccessToken.from_hash(consumer,token)
    
    # 0.5.1
    token = {
      oauth_token: access_token, oauth_token_secret: access_token_secret
    }
    return OAuth::RequestToken.from_hash(consumer,token)
  end

end


