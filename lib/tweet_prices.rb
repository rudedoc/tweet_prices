require 'tweet_prices/version'
require 'nokogiri'
require 'open-uri'

module TweetPrices

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
        market = Market.new(self.class, kick_off_time)
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
    attr_accessor :event_list, :uri

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
    attr_accessor :name, :price

    def initialize(name, price)
      @name, @price = name, price
    end
  end

  class Comparer
    attr_reader :common_events, :comparison_sets

    def initialize(xml, oc)
      @common_events = get_common_events(xml, oc)
      @comparison_sets = get_comparison_sets
    end

    private

    def get_comparison_sets
      comparison_sets = []
      bookies = ["BY", "PP"]
      @common_events.each do |event|
        html_doc = Nokogiri::HTML((open event[:url]))
        comparison_set = ComparisonSet.new
        bookies.each do |bookie|
          market = Market.new(bookie)
          html_doc.xpath("//tbody[@id='t1']/tr").each do |competitor|
            competitor_id = competitor.xpath('@data-participant-id').text
            market.competitors << Competitor.new(competitor.xpath('td[2]').text, competitor.xpath("td[@id='#{competitor_id}_#{bookie}']").text)
          end
          comparison_set.market_quotes << market
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
  end

end