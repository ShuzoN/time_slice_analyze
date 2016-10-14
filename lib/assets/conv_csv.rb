require 'pathname'

# ファイル指定有無の確認
def self.check_file_path(path)
  if path == nil
    puts 'illegal argument. please enter the path of target file.'
    return
  end
  return path
end

def self.file_exist?(f_path)
  unless f_path.cleanpath.file?
    puts 'Does not exist the target file. Check the file path.'
    return 
  end
  return true
end

def conv_csv

  path_str = ARGV[0]

  # ファイル指定有無の確認
  return unless check_file_path(path_str)

  # ファイルが存在するか確認
  f_path = Pathname.new(path_str.to_s)
  return unless file_exist?(f_path)

  # csv用のバッファ
  csv=""



  # 対象ファイルを1行づつ読みcsvに変換する
  f = File.open(f_path,'r')

  # BOM宣言
  csv_line = "\xEF\xBB\xBF"
  f.read.each_line do |fl|
    # csv1行に相当する文字列
    # 区間, 単語, tfidf値になるように出力

    line_str = fl.rstrip

    if csv_line.include?("\n")
      csv << csv_line
      csv_line = ""
    end

    # 区切り文字の処理
    if line_str.match(/---/)
      csv_line << "#{line_str}"

    # 10進数字の場合(tfidf値の場合)
    elsif line_str.match(/\d/)
      csv_line << ",#{line_str}"
      csv_line << "\n"

    # 非10進数字の場合(単語の場合)
    elsif line_str.match(/\D/)
      csv_line << ",#{line_str}"
    end


  end

  # csv書き出し
  # UTF-16LEじゃないとMac版Excelは文字化けを起こす
  wf_path = f_path.to_s.gsub(/.txt/,"") + ".csv"
  wf = File.open(wf_path,'w:UTF-16LE')
  wf.write(csv)
  wf.close

  f.close
end

# execute
conv_csv()


