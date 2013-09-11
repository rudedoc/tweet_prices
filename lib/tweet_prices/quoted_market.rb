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

    def competitors
      @competitors.sort! {|a,b| a.name.downcase <=> b.name.downcase }
    end

    def name
      competitors.collect {|competitor| competitor.name.capitalize}.join.gsub(" ", "").gsub(".", "")
    end
  end
end