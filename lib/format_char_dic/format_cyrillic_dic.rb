require "bundler"
Bundler.require

# 生成したキリル辞書の生成
class FormatCyrillicDic
  include FormatCharDic::FormatDic

  def main
    dic_path = "../../../config/dictionary/cyrillic"
    f_import = "cyrillic.txt"
    f_export = "formated_cyrillic.txt"
    shape_dictionary(dic_path, f_import, f_export)
  end
end
FormatCyrillicDic.new.main
