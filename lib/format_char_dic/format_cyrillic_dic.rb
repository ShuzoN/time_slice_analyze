require "bundler"
Bundler.require

# 生成したキリル辞書の生成
class FormatCyrillicDic
  # 生成した絵文字辞書の生成
  def main
    dic_path = "../../../config/dictionary/cyrillic"
    emoji_files = file_open(dic_path)

    data_dic = cyrillic_files

    # 絵文字の辞書を生成
    emoji_dic = format_emoji_dic_for_data(data_dic)

    # 整形した絵文字辞書を書き込み
    formated_emoji = File.expand_path( 
      dic_path + "/formated_cyrillic.txt", __FILE__)
    File.open(formated_emoji, "w").write(emoji_dic.join(","))
  end

  # 1つの16進数からなる絵文字の辞書を生成
  def format_emoji_dic_for_data(emoji_data_dic)
    dic = [] # 絵文字の辞書(unicode codepoint:16進数)
    emoji_data_dic.lines.each do |emoji|
      # 辞書から絵文字のUnicodeを取得
      emoji_unicode = emoji.split(/;/)[0].strip
      break if emoji_unicode == "EOF"
      # カテゴリを展開して辞書に格納する
      if emoji_unicode.include?("..")
        dic_snippet = deployment_category(emoji_unicode, dic)
        dic << dic_snippet if dic_snippet

      # 絵文字が単体で表記されている場合
      elsif dic << emoji_unicode.to_i(16)
      end
    end
    dic.flatten!
  end

  # 複数の16進数からなる絵文字の辞書を生成
  def format_emoji_dic_for_seq(emoji_seq_dic)
    dic = [] # 絵文字の辞書(unicode codepoint:16進数)
    emoji_seq_dic.lines.each do |emoji|
      emoji_unicode = emoji.split(/;/)[0].strip
      break if emoji_unicode == "EOF"
      emoji_cp = ""
      emoji_unicode.split("\s").each do |e_uni|
        emoji_cp << e_uni.to_i(16).to_s + " "
      end
      dic << emoji_cp.strip
    end
    dic
  end

  # 絵文字がカテゴリでまとめてRangeで表現されている場合がある
  # 展開して辞書に格納する
  def deployment_category(emoji_unicode, dic)
    e_unicodes     = emoji_unicode.gsub("..", ".").split(".")
    uni_cp_first   = e_unicodes[0].to_i(16) # コードポイントに変換
    uni_cp_last    = e_unicodes[-1].to_i(16)
    (uni_cp_first..uni_cp_last).to_a.each do |cp|
      dic << cp
    end
  end

  def file_open(dic_path)
    # 絵文字の辞書ファイルを開く
    emoji_dat_locate = File.expand_path(
      dic_path + "/emoji_data.txt", __FILE__)

    data_dic = File.open(emoji_dat_locate, "r").read

    data_dic, seq_dic, zwj_dic
  end
end
FormatEmojiDic.new.main
