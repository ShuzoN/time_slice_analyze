require "bundler"
Bundler.require

# 生成した絵文字辞書の生成
class FormatEmojiDic
  include FormatCharDic::FormatDic

  def main
    dic_path  = "../../../config/dictionary/emoji"
    f_import = "emoji.txt"
    f_export = "formated_emoji.txt"
    shape_dictionary(dic_path, f_import, f_export)
  end
end
FormatEmojiDic.new.main
