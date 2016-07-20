require "bundler"
Bundler.require

# 生成した絵文字辞書の生成
class FormatGreekDic
  include FormatCharDic::FormatDic

  def main
    dic_path = "../../../config/dictionary/greek"
    f_import = "greek.txt"
    f_export = "formated_greek.txt"
    shape_dictionary(dic_path, f_import, f_export)
  end
end
FormatGreekDic.new.main
