module TweetPrices
  class QuotedMarket
    attr_accessor :competitors, :bookmaker

    def initialize(bookmaker, kick_off=nil)
      @bookmaker, @kick_off = bookmaker, kick_off
      @competitors = []
    end

    def competitor_names
      @competitors.collect { |competitor| competitor.name }
    end
  end
end