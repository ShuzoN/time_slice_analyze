class User

  # アクセッサ
  attr_accessor :id, :screen_name, :description 

  # コンストラクタ
  def initialize
    @id          = ""  #user id
    @screen_name = 0   #表示 id
    @description = ""  #profile
  end
end
