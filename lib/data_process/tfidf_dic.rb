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

def cut_interval(content)
    csv_content = content
    raise ArgumentError if !content.kind_of?(String)

    # 区間ごとの内容
    # ["0:100", ",保育士,0.0032\n,宇治原,0.0026\n...", "100:200",...]
    separeted_details = csv_content.split(/(\d{1,4}:\d{1,4})/).rotate

    separated_details_hash={}
    separeted_details.each_slice(2) do |range, values|
      break if !range.kind_of?(String) || !values.kind_of?(String)
      separated_details_hash.store(range,values)
    end
    return separated_details_hash
end

filename = "tmp/tfidf_result_hashimoto_100.csv"
tfidf_result = read_csv(filename)
cut_interval(tfidf_result)
