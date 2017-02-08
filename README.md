
---
### 環境設定
---

利用しているソフトウェアのバージョンは以下
```
mac os x el capitan(linuxでも動くはず)
rbenv 1.0.0
bundler 1.13.6
ruby 2.2.0 
ruby on rails 4.2.1
sqlite3 3.8.10.2(gem:1.3.11)
```

環境設定が面倒だったら, [こちら](https://github.com/ShuzoN/rails_practice)を参照してください. 自動でubuntu14.04LTSがインストールされたVMが起動し, railsが動作するところまでは作ってくれるはず.   
このプロジェクトを動かすことに関しては, [ここ](https://github.com/ShuzoN/time_slice_analyze)をgit cloneして, bundle installすれば多分動くと思う(謎). もちろんrails側でmigrateなどの処理は必要. railsがわからない場合は, dotinstallなどで簡単に学習するといい.  
ハマったら調べてください. 環境設定の方法は僕も忘れました.  

1. homebrewの導入(macのみ)
  [本家サイト](http://brew.sh/index_ja.html)

2. rbenvのインストール
  [Qiita rbenvでrubyの環境を整える]((http://qiita.com/ringo/items/4351c6aee70ed6f346c8)
  rbenvはrubyのバージョン管理システム. 
  rbenvを使うことで, 複数のrubyのバージョンをインストールできる.
  そして, バージョンごとに異なる環境として扱うことが出来るため, 
  パッケージの管理が楽になる.  

  
3. ruby2.2.0のインストール
  [rbenvでruby2.2.0をインストールする.  ](http://dev.classmethod.jp/server-side/language/build-ruby-environment-by-rbenv/)

4. bundlerのインストール
  [手順はこちらから](http://qiita.com/tokimari/items/51ac63a1fe244b819aea)
  bundlerは, rubyのパッケージ管理ソフト. 
  rubyのパッケージをプロジェクトレベルで管理できる.
  通常は, rubyのバージョンごとにパッケージを追加していく. 
  bundlerを使うことで, 同じバージョンのrubyでも
  プロジェクトごとに別々のgemを使用することができる. 
  
5. プロジェクトにgem(rubyのパッケージ)のインストール
```
# カレントディレクトリ配下にvendor/bundlerディレクトリを生成
# そこにgemの本体を配置する
$ bundle install --path vendor/bundle --jobs=10
```

---
### ディレクトリ構造
---
.  
├── Gemfile  
├── Gemfile.lock  
├── README.md  
├── Rakefile  
├── app  
│   └── models  
├── config  
│   ├── application.rb  
├── config.ru  
├── lib  
│   ├── assets  
│   ├── data_process  
│   ├── dic  
│   ├── document  
│   ├── format_char_dic  
│   ├── method    
│   ├── tasks  
│   ├── test  
│   └── twitter_connection  
├── tmp  
│   ├── entropy  
│   ├── hashimoto_100  
│   ├── hashimoto_300  
│   ├── hashimoto_500  
│   ├── most_freq_noun_in_hashimoto_tweets.txt  
│   ├── noun.txt  
│   └── num_docs_contain_word.txt  
└── vendor  
    └── bundle  

使用するディレクトリのみを掲載.  
app/models以下でモデルの動作を定義.  
lib以下に, 計算を行うプログラムを置いた.  
ファイル出力は/tmpに出力.  
その他のディレクトリはほとんど触っていない.  

例外的に, 自作クラスを読み込むためにlib以下にパスを通した.   
[ここを参考にした](http://qiita.com/azusanakano/items/885fe3236977580b00c9)  

---
### プログラムの実行方法
---

Railsの環境でrubyのスクリプトを実行する
```
# Rails環境下でrubyを実行(このコマンドは実際動作しないので注意)
$ bundle exec rails runner lib/assets/main.rb

# irb, ruby コマンドはRails環境を読まないため, 実行時にエラーになる
$ bundle exec ruby lib/assets/main.rb #=> error
```

---
### 自作スクリプトの利用
---
Rails環境下で自作スクリプトを読みこませるには,   
``lib``配下にスクリプトを配置する必要がある. 

プログラム内での宣言が特殊であるため, 注意が必要. 
どうやら``lib/``をルートディレクトリとして, 
相対的パスで指定するようだ. 

```
# lib/assets/test.rbを読み込む場合
def main
  test = Assets::Test.new
end

# lib/document/generate/by_count.rbを読み込む場合
def main
  doc = Document::Generate::ByCount.new
end
```

Rails本来の使い方としては, Appに共通するモジュールの自作に使う機能らしい.  

