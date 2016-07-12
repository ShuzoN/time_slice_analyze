# 絵文字の辞書を生成するクラス
class Dic::Emoji
  attr_reader :dic

  def initialize
    # 絵文字を記録する辞書
    @dic = generate_emoji_dic
  end

  # 絵文字辞書を生成
  def generate_emoji_dic
    dic = [""]
    # 辞書ファイルの指定
    emoji_dic_location = \
      File.expand_path("../../../config/dictionary/emoji_data.txt", __FILE__)
    emoji_txt = File.open(emoji_dic_location, "r").read

    # 辞書の生成
    emoji_txt.each_line do |em|
      next  if em.chr.nil? || em.chr == ""
      break if em.chr == "EOF".chr
      dic << em.split(";")[0].strip.to_sym
    end
    dic
  end
end
