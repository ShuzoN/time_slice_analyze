# UTF8文字列の3byte16進数を整数に変換する
module FormatCharDic::FormatDic

  def shape_dictionary(dic_path, import_file, export_file)
    file_cache = file_read(dic_path, import_file)

    # 3byte, 範囲指定, 複数の3byteからなる文字をそれぞれ抽出
    uni_single, uni_range, uni_multis = extract_unicode(file_cache)
    dic = []
    dic << format_3byte(uni_single)
    dic << format_range(uni_range)
    dic << format_multi_3byte(uni_multis)
    dic.flatten!
    dic.uniq!
    
    formated_dic = File.expand_path( \
      dic_path + "/" + export_file, __FILE__)
    File.open(formated_dic, "w").write(dic.join(","))
  end

  # 3byte文字を処理
  def format_3byte(unicodes_hex)
    dic = []
    unicodes_hex.each do |uc|
      dic << uc.to_i(16)
    end
    dic
  end

  # Rangeで表現されている文字を処理
  def format_range(uni_range_hex)
    dic = []
    uni_range_hex.each do |uc_range|
      dic << deployment_range(uc_range)
    end
    dic.flatten
  end

  # 複数の3byte文字からなる文字を処理
  def format_multi_3byte(uni_multis)
    dic = []
    uni_multis.each do |um|
      cp = ""
      um.split("\s").each do |uni|
        cp << uni.to_i(16).to_s + " "
      end
      dic << cp.strip
    end
    dic
  end

  # 辞書ファイルの読み込み
  def file_read(dic_path, file_name)
    return if file_name.nil? || file_name.empty?
    file_name << ".txt" unless file_name.include?(".txt")
    locate = File.expand_path(dic_path + "/#{file_name}", __FILE__)
    file = File.open(locate, "r").read
    file
  end

  # 元ファイルからunicodeを抽出
  def extract_unicode(file_cache)
    uni_single = []
    uni_range  = []
    uni_multi  = []

    file_cache.lines.each do |char_line|
      # unicodeを取得
      unicode = char_line.split(/;/)[0].strip
      break if unicode == "EOF"

      if range?(unicode)
        uni_range  << unicode
      elsif multi?(unicode)
        uni_multi  << unicode
      else
        uni_single << unicode
      end
    end
    return uni_single, uni_range, uni_multi
  end

  private 
  # 1つの3byteで表現されているUTF8文字コードを展開する
  def range?(unicode)
    unicode.include?("..")
  end

  # 複数の3byteで表現されているUTF8文字コードを展開する
  def multi?(unicode)
    return nil if unicode.include?("..")
    return nil if unicode.size <= 4
    unicode.include?("\s")
  end

  # Rangeで表現されているUTF8文字コードを展開する
  def deployment_range(uni_ranges)
    dic = []
    ucs        = uni_ranges.gsub("..", ".").split(".")
    cp_first   = ucs[0].to_i(16) # コードポイントに変換
    cp_last    = ucs[-1].to_i(16)
    (cp_first..cp_last).to_a.each do |cp|
      dic << cp
    end
    dic
  end
end
