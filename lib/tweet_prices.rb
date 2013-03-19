module TweetPrices
  VERSION = "0.0.1"
  require 'nokogiri'
  require 'open-uri'

  class Tweeter

    def initialize(comparison_set)
      puts comparison_set.hashed_market_quotes

    end

  end

  class XML
    attr_reader :markets

    def initialize(url)
      @markets = parse_markets(Nokogiri::XML(open(url)))
    end

    private

    def parse_markets(data)
      markets = []
      data.xpath('//event').each do |event|
        date = event.xpath('bettype').first.xpath("@bet-start-date").text
        time = event.xpath('bettype').first.xpath("@bet-start-time").text
        kick_off_time = Time.parse("#{date}T#{time}")
        market = Market.new("XML", kick_off_time)
        event.xpath('bettype').first.xpath('bet').each do |bet|
          name = bet.xpath('@name').text.downcase
          price = bet.xpath('@price').text
          market.competitors << Competitor.new(name, price)
        end
        markets << market
      end
      markets
    end
  end

  class OddsChecker
    attr_accessor :event_list

    def initialize(url)
      @event_list = parse_events(Nokogiri::HTML(open(url)))
    end

    def parse_events(data)
      events = []
      data.xpath("//tr[@class='match-on']").each do |event|
        competitors = []
        competitors << event.xpath('td[2]/p/span[2]').text.downcase
        competitors << event.xpath('td[3]/p/span[2]').text.downcase
        competitors << event.xpath('td[4]/p/span[2]').text.downcase
        url = event.xpath('td[5]/a/@href').text
        events << {:competitors => competitors, :url => ("http://www.oddschecker.com" + url)}
      end
      events
    end
  end

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
      @common_events = get_common_events(xml, oc)
      @comparison_sets = get_comparison_sets(xml)
    end

    private

    def get_comparison_sets(xml)
      comparison_sets = []
      bookies = ["BY", "PP"]
      @common_events.each do |event|
        html_doc = Nokogiri::HTML((open event[:url]))
        comparison_set = ComparisonSet.new
        bookies.each do |bookie|
          market = Market.new(bookie)
          html_doc.xpath("//tbody[@id='t1']/tr").each do |competitor|
            competitor_id = competitor.xpath('@data-participant-id').text
            market.competitors << Competitor.new(competitor.xpath('td[2]').text.downcase, competitor.xpath("td[@id='#{competitor_id}_#{bookie}']").text)
          end
          comparison_set.market_quotes << market
          xml.markets.each do |xml_market|
            if (xml_market.competitor_names & market.competitor_names).count == 3
              comparison_set.market_quotes << xml_market unless comparison_set.market_quotes.collect { |quote| quote.bookmaker }.include?("XML")
            end
          end
          comparison_sets << comparison_set
        end
      end
      comparison_sets
    end

    def get_common_events(xml, oc)
      xml_event_list = xml.markets.collect { |market| market.competitors.collect { |competitor| competitor.name } }
      common_events = []
      oc.event_list.each do |event|
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