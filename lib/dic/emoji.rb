# 絵文字の辞書を生成するクラス
class Dic::Emoji
  # 絵文字を記録する辞書
  @dic = []

  # 絵文字辞書を生成
  def generate_emoji_dic
    # 辞書ファイルの指定
    emoji_dic_location = \
      File.expand_path("../../config/dictionary/emoji_data.txt", __FILE__)
    emoji_txt = File.open(emoji_dic_location, "r").read
    puts 'in'

    # 辞書の生成
    emoji_txt.each_line do |em_line|
      @@dic << em_line.split(";")[0]
    end
    @dic
  end
end

em = Dic::Emoji.new
em.generate_emoji_dic
