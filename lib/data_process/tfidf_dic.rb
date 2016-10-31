require 'pathname'

# csvファイルを読み込んで, 文字列を返す
def read_csv(filename)
  begin
    # 引数で渡されたファイルパスを基に
    # ファイルオープン
    csv_filepath = "#{filename}"
    raise ArgumentError if !filename.kind_of?(String)
    f_path = Pathname.new(csv_filepath)
    raise IOError, "file not exist. enter filepath : #{f_path}" unless f_path.cleanpath.file?

    # CSVがUTF-16で保存されているのでUTF8に変換
    f = File.open(f_path,'r:UTF-16LE:UTF-8')
    content = f.read()
    f.close
    return content
  rescue => e
    puts e.inspect; puts $@; exit 1
  end
end
