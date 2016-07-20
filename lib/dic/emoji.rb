# 絵文字の辞書を生成するクラス
class Dic::Emoji < Dic::Dic
  def initialize
    # 絵文字を記録する辞書
    dic_lct = File.expand_path(
      "../../../config/dictionary/emoji/formated_emoji.txt", __FILE__)
    @dic = generate_dic(dic_lct)
  end
end
