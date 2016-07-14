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
    emoji_dic_location = File.expand_path(
      "../../../config/dictionary/formated_emoji.txt", __FILE__)
    emoji_txt = File.open(emoji_dic_location, "r").read

    # 辞書の生成
    dic = emoji_txt.split(/,/)
    dic
  end

  # 単語をutf8の文字コードに変換する(U+は省略)
  def self.convert_utf_code(word)
    utf_code_point = word.unpack("U*") # array
    utf_code = ""
    utf_code_point.each do |cp|
      utf_code << cp.to_s + " "
    end
    utf_code.strip
  end
end
