require "bundler"
Bundler.require

# 生成したギリシャ辞書の生成
class FormatLatinDic
  include FormatCharDic::FormatDic

  def main
    dic_path = "../../../config/dictionary/latin"
    f_import = "latin.txt"
    f_export = "formated_latin.txt"
    shape_dictionary(dic_path, f_import, f_export)
  end
end
FormatLatinDic.new.main
