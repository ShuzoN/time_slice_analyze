# 文字辞書を生成するクラス
class Dic::Dic
  attr_reader :dic

  def initialize
    @dic
  end

  # 絵文字辞書を生成
  def generate_dic(dic_lct)
    # 辞書ファイルの読み込み
    chr_txt = File.open(dic_lct, "r").read

    # 辞書の生成
    dic = chr_txt.split(/,/)
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
