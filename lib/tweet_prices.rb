module TweetPrices
  VERSION = "0.0.1"
  require 'nokogiri'
  require 'open-uri'

  require 'tweet_prices/xml_client'
  require 'tweet_prices/oddschecker_client'
  require 'tweet_prices/quoted_market'
  require 'tweet_prices/competitor'
  require 'tweet_prices/comparer'
end