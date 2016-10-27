
require "bundler"
Bundler.require
require 'leveldb'


@db = LevelDB::DB.new("./lib/test/testdb")

# dbにKey:string => Value:Hashの形で記録する
# leveldbは, 文字列のみ記録可能
# hashを文字列に変換して記録する
def put(orgkey, value_hash)
  begin 
    key = orgkey

    if !orgkey.kind_of?(String)
      raise ArgumentError, "type error. require String. #{key.class}" 
    elsif !value_hash.kind_of?(Hash)
      raise ArgumentError, "type error. require Hash. #{value_hash.class}" 
    end

    @db[key] = value_hash.to_s

  rescue ArgumentError=> ex
     puts __FILE__ + "  " + ex.inspect 
    exit 1
  end
end

# dbからKeyに対応するvalueを取得
# 文字列からHashを復元する
# 戻り値 : Hash
def get(key)
  begin 
    if !key.kind_of?(String)
      raise ArgumentError, "type error. require String. #{key.class}" 
    end

    # dbから値の取得
    result_value = @db[key]

    raise KeyError, "#{key} has no value." unless result_value


    # dbから受け取ったデータをString -> Hash変換
    result_hash = eval(result_value)

    raise TypeError unless result_hash.kind_of?(Hash)

    return result_hash

  rescue ArgumentError=> ex
    puts __FILE__ + "  " + ex.inspect 
    exit 1
  end
end



strings = ["one", "two", "three", "four", "five", "six", "seven", "eight", "night","ten"]
values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

test_hash = Hash.new

strings.each.with_index do |key, sidx|
  value = values[sidx] 
  test_hash.store(key, value)
end


p @db.keys

# put("1", test_hash)
p get("1")
