# 絵文字の辞書を生成するクラス
class Dic::Latin < Dic::Dic
  def initialize
    # 絵文字を記録する辞書
    dic_lct = File.expand_path(
      "../../../config/dictionary/latin/formated_latin.txt", __FILE__)
    @dic = generate_dic(dic_lct)
  end
end
