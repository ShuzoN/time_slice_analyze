require "bundler"
Bundler.require

class FormatEmojiDic
  def main
    # 絵文字の辞書ファイルを開く
    emoji_dic_location = \
      File.expand_path("../../../config/dictionary/emoji_data.txt", __FILE__)
    emoji_org_dic = File.open(emoji_dic_location, "r").read

    # 絵文字辞書(unicode codepoint:16進数)
    emoji_dic = []
    # 1つの16進数からなる絵文字の辞書を生成
    emoji_dic = format_emoji_dic_for_data(emoji_org_dic)
  end

  # 1つの16進数からなる絵文字の辞書を生成
  def format_emoji_dic_for_data(emoji_org_dic)
    # 絵文字の辞書(unicode codepoint:16進数)
    dic = []

    emoji_org_dic.lines.each do |emoji|
      # 辞書から絵文字のUnicodeを取得
      emoji_unicode = emoji.split(/;/)[0].strip
      break if emoji_unicode == "EOF"
      # カテゴリを展開して辞書に格納する
      if emoji_unicode.include?("..")
        dic_snippet = deployment_category(emoji_unicode, dic)
        dic << dic_snippet if dic_snippet

      # 絵文字が単体で表記されている場合
      elsif dic << emoji_unicode
      end
    end
    dic.flatten
  end

  # 絵文字がカテゴリでまとめてRangeで表現されている場合がある
  # 展開して辞書に格納する
  def deployment_category(emoji_unicode, dic)
    e_unicodes     = emoji_unicode.gsub("..", ".").split(".")
    uni_cp_first   = e_unicodes[0].to_i(16) # コードポイントに変換
    uni_cp_last    = e_unicodes[-1].to_i(16)
    (uni_cp_first..uni_cp_last).to_a.each do |cp|
      dic << format("%04x", cp).upcase
    end
  end
end

FormatEmojiDic.new.main
