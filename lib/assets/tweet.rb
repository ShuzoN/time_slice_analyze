class Tweet

  # アクセッサ
  attr_accessor :date, :id, :text, :user

  # コンストラクタ
  def initialize
    @date = ""  #tweet 日時
    @id   = 0   #tweet 固有id
    @text = ""  #tweet 内容
    @user       #tweet したuser
  end
end
