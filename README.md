### 実行環境について
実行環境 : OS X El Capitan / mac book air 2013
環境設定 : 
 - rbenv 1.0.0
 - bundler 1.13.6
 - ruby 2.2.0 
 - ruby on rails 4.2.1
 - sqlite3 3.8.10.2(gem:1.3.11)
 gemについてはGemfileを参照してください

### プログラムの実行

Railsの環境でrubyのスクリプトを実行する
```
# Rails環境下でrubyを実行
$ rails runner lib/assets/main.rb

# irb, ruby コマンドはRails環境を読まないため, 実行時にエラーになる
$ ruby lib/assets/main.rb #=> error
```

### 自作スクリプトの利用
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
Javaのような書き方になっているので気持ち悪いが, とても便利なので目をつむっている.

## 環境設定

利用しているソフトウェアのバージョンは以下
```
mac os x el capitan(linuxでも動くはず)
rbenv 1.0.0
ruby 2.2.0(rbenvでインストール)
bundler 1.11.2
git 2.6.2
```

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


### ディレクトリ構造
.
├── Gemfile
├── Gemfile.lock
├── README.md
├── Rakefile
├── app
│   └── models
├── bin
│   ├── bundle
│   ├── rails
│   ├── rake
│   ├── setup
│   └── spring
├── config
│   ├── application.rb
│   ├── boot.rb
│   ├── database.yml
│   ├── dictionary
│   ├── environment.rb
│   ├── environments
│   ├── initializers
│   ├── locales
│   ├── routes.rb
│   └── secrets.yml
├── config.ru
├── count_most_frequence_word_in_hashimoto_tweets.rb
├── count_noun_per_month.rb
├── count_noun_per_tw_count.rb
├── db
│   ├── development.sqlite3
│   ├── migrate
│   ├── schema.rb
│   └── seeds.rb
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
├── log
│   ├── -o.log
│   └── development.log
├── most_freq_noun_in_hashimoto_tweets.txt
├── tags
├── test
│   ├── controllers
│   ├── fixtures
│   ├── helpers
│   ├── integration
│   ├── mailers
│   ├── models
│   └── test_helper.rb
├── tmp
│   ├── entropy
│   ├── hashimoto_100
│   ├── hashimoto_300
│   ├── hashimoto_500
│   ├── noun.txt
│   └── num_docs_contain_word.txt
└── vendor
    ├── assets
        └── bundle

