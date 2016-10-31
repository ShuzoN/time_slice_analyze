require 'pathname'

begin 
  csv_filename = "tfidf_result_hashimoto_100.csv"
  csv_filepath = "tmp/#{csv_filename}" 
  f_path = Pathname.new(csv_filepath.to_s)
  raise IOError, "file not exist." unless f_path.cleanpath.file?
  f = File.open(f_path,'r:UTF-16LE:UTF-8')
  content = f.read()
  f.close

  puts content

rescue IOError => e
  e.inspect
end
