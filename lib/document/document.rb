class Document::Document

  def initialize
    @division_mark = "<div_mark>" # Tweetの区切り
  end

  def read()

  end

  def write()

  end

  def self.to_d(tweet_group)
    return tweet_group.pluck(:text).join(@division_mark)
  end
end
