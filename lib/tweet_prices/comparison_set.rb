module TweetPrices
  class ComparisonSet
    attr_accessor :market_quotes

    def initialize
      @market_quotes = []
    end

    def hashed_market_quotes
      comparison_hash = {}
      @market_quotes.each do |quote|
        quote.competitors.each do |competitor|
          if comparison_hash[competitor.name] == nil
            comparison_hash[competitor.name] = [[quote.bookmaker, competitor.price_decimal, quote]]
          else
            comparison_hash[competitor.name] << [quote.bookmaker, competitor.price_decimal, quote]
          end
        end
      end
      sort_quotes(comparison_hash)
    end

    private

    def sort_quotes(comparison_hash)
      sorted_hash = {}
      comparison_hash.each do |key, value|
        sorted_hash[key] = value.sort_by { |bookie, price| price }
      end
      sorted_hash
    end
  end
end