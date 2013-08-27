module TweetPrices
  class XmlClient
    attr_reader :markets

    def initialize(url)
      @markets = parse_markets(Nokogiri::XML(open(url)))
    end

    private

    def parse_event_to_market(event)
      date = event.xpath('bettype').first.xpath("@bet-start-date").text
      time = event.xpath('bettype').first.xpath("@bet-start-time").text
      kick_off_time = Time.parse("#{date}T#{time}")
      Market.new("XML", kick_off_time)
    end

    def parse_bet_to_competitor(bet)
      name = bet.xpath('@name').text.downcase
      price = bet.xpath('@price').text
      Competitor.new(name, price)
    end

    def parse_markets(data)
      markets = []
      data.xpath('//event').each do |event|
        market = parse_event_to_market(event)
        event.xpath('bettype').first.xpath('bet').each do |bet|
          market.competitors << parse_bet_to_competitor(bet)
        end
        markets << market
      end
      markets
    end
  end
end