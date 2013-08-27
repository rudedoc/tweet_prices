module TweetPrices
  VERSION = "0.0.1"
  require 'nokogiri'
  require 'open-uri'
  BOOKMAKERS = ["BY", "PP"]

  require 'tweet_prices/xml_client'
  require 'tweet_prices/oddschecker_client'




  class Market
    attr_accessor :competitors, :bookmaker

    def initialize(bookmaker, kick_off=nil)
      @bookmaker, @kick_off = bookmaker, kick_off
      @competitors = []
    end

    def competitor_names
      @competitors.collect { |competitor| competitor.name }
    end
  end

  class Competitor
    attr_accessor :name, :price, :price_decimal

    def initialize(name, price)
      @name, @price = name, price
      @price_decimal = decimal_price
    end

    def decimal_price
      numerator, denominator = @price.split('/')
      (numerator.to_f / denominator.to_f).round(2)
    end
  end

  class Comparer
    attr_reader :common_events, :comparison_sets

    def initialize(xml, oc)
      @xml = xml
      @oc = oc
      @common_events = get_common_events
      @comparison_sets = get_comparison_sets
    end

    private

    def build_competitor(competitor_xml, bookie)
      competitor_id = competitor_xml.xpath('@data-participant-id').text
      price = competitor_xml.xpath("td[@id='#{competitor_id}_#{bookie}']").text
      name = competitor_xml.xpath('td[2]').text.downcase
      Competitor.new(name, price)
    end

    def parse_market(html_doc, bookie)
      market = Market.new(bookie)
      html_doc.xpath("//tbody[@id='t1']/tr").each do |competitor_xml|
        competitor = build_competitor(competitor_xml, bookie)
        market.competitors << competitor
      end
      market
    end

    def matching_competitors?(xml_market, market)
      (xml_market.competitor_names & market.competitor_names).count == 3
    end

    def build_comparison_set(html_doc, bookie)
      comparison_set = ComparisonSet.new
      market = parse_market(html_doc, bookie)
      comparison_set.market_quotes << parse_market(html_doc, bookie)
      @xml.markets.each do |xml_market|
        if matching_competitors?(xml_market, market)
          comparison_set.market_quotes << xml_market unless comparison_set.market_quotes.collect { |quote| quote.bookmaker }.include?("XML")
        end
      end
      comparison_set
    end

    def get_comparison_sets
      comparison_sets = []
      @common_events.each do |event|
        html_doc = Nokogiri::HTML((open event[:url]))
        BOOKMAKERS.each do |bookie|
          comparison_sets << build_comparison_set(html_doc, bookie)
        end
      end
      comparison_sets
    end

    def get_common_events
      xml_event_list = @xml.markets.collect { |market| market.competitors.collect { |competitor| competitor.name } }
      common_events = []
      @oc.events.each do |event|
        xml_event_list.each do |market|
          if (event[:competitors] & market).count == 3
            common_events << event
          end
        end
      end
      common_events
    end
  end

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