require "bundler"
Bundler.require

# 生成した絵文字辞書の生成
class FormatEmojiDic
  include FormatCharDic::FormatDic

  def main
    dic_path  = "../../../config/dictionary/emoji"
    file_name = "emoji.txt"
    file_cache = file_read(dic_path, file_name)

    # 3byte, 範囲指定, 複数の3byteからなる文字をそれぞれ抽出
    uni_single, uni_range, uni_multis = extract_unicode(file_cache)
    emoji_dic = []
    emoji_dic << format_3byte(uni_single)
    emoji_dic << format_range(uni_range)
    emoji_dic << format_multi_3byte(uni_multis)
    emoji_dic.flatten.uniq!
    
    formated_emoji = File.expand_path( \
      dic_path + "/formated_emoji.txt", __FILE__)
    File.open(formated_emoji, "w").write(emoji_dic.join(","))
  end
end
FormatEmojiDic.new.main
