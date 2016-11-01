
require "bundler"
Bundler.require
require 'leveldb'

class DataProcess::TfidfDB

  # ユーザ名に合わせたKVSDBの作成
  def initialize(username:"hashimoto", interval: 100 )
    begin
      # 引数の型チェック
      raise ArgumentError if !username.kind_of?(String)
      raise ArgumentError if !interval.kind_of?(Numeric)

      dbpath = "./tmp/" + username + "_" + interval.to_s
      @db = LevelDB::DB.new(dbpath)
    rescue ArgumentError=> ex 
      puts $@ + "  " + ex.inspect 
      exit 1
    end
  end

  # dbにKey:string => Value:Hashの形で記録する
  # leveldbは, 文字列のみ記録可能
  # hashを文字列に変換して記録する
  def put(org_key, value_hash)
    begin 
      key = org_key
      raise ArgumentError if !org_key.kind_of?(String)
      raise ArgumentError if !value_hash.kind_of?(Hash)

      @db[key] = value_hash.to_s

    rescue ArgumentError=> ex
      puts $@ + "  " + ex.inspect 
      exit 1
    end
  end

  # dbからKeyに対応するvalueを取得
  # 文字列からHashを復元する
  # 戻り値 : Hash
  def get(key)
    begin 
      raise ArgumentError if !key.kind_of?(String)

      # dbから値の取得
      result_value = @db[key]

      raise KeyError unless result_value


      # dbから受け取ったデータをString -> Hash変換
      result_hash = eval(result_value)

      raise TypeError unless result_hash.kind_of?(Hash)

      return result_hash

    rescue ArgumentError=> ex
      puts $@ + "  " + ex.inspect 
      exit 1
    end
  end

  def delete(key)
    begin
      raise ArgumentError if !key.kind_of?(String)
      @db.delete(key)
    rescue ArgumentError=> ex
      puts $@ + "  " + ex.inspect
      exit 1
    end
  end

  def keys
    @db.map do |k, v| k.force_encoding("utf-8") end
  end

  def values
    @db.values
  end
end

# usage
# keywords = ["バイブル", "テクノロジ", "サイクル", "選挙"]
# word1_tfidf = {"100:200"=>0.0023, "200:300"=>0.00356, "300:400"=>0.00456}
# word2_tfidf = {"100:200"=>0.0223, "200:300"=>0.02252, "300:400"=>0.01456}
# word3_tfidf = {"100:200"=>0.0531, "200:300"=>0.00450, "300:400"=>0.00562}
# word4_tfidf = {"100:200"=>0.0823, "200:300"=>0.00474, "300:400"=>0.04456}
# value = [word1_tfidf,word2_tfidf,word3_tfidf,word4_tfidf]
#
# db = TfidfValueDB.new("testdb")
#
# keywords.each.with_index do |key, sidx|
#   db.put(key, value[sidx])
# end
#
# p db.get("サイクル")
# p db.keys
# p db.values
