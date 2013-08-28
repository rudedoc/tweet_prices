module TweetPrices
  VERSION = "0.0.1"
  require 'nokogiri'
  require 'open-uri'

  require 'tweet_prices/xml_client'
  require 'tweet_prices/oddschecker_client'
  require 'tweet_prices/market'
  require 'tweet_prices/competitor'
  require 'tweet_prices/comparer'
  require 'tweet_prices/comparison_set'
end