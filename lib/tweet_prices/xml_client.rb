module TweetPrices
  class XmlClient
    attr_reader :markets, :url, :source_name

    def initialize(options)
      @source_name = options[:source_name] || "XM"
      @url = options[:url]
      @markets = create_markets(Nokogiri::XML(open(@url)))
    end

    private

    def create_markets(data)
      data.xpath('//event').map do |event|
        market = create_market(event)
        market.competitors = market_competitors(event)
        market
      end
    end

    def create_market(event)
      date = event.xpath('bettype[1]/@bet-start-date').text
      time = event.xpath('bettype[1]/@bet-start-time').text
      kick_off_time = Time.parse("#{date}T#{time}")
      QuotedMarket.new(source_name, kick_off_time) # change "XML" to source_identifier option
    end

    def market_competitors(event)
      event.xpath('bettype[1]/bet').collect { |bet| create_competitor(bet) }
    end

    def create_competitor(bet)
      name = bet.xpath('@name').text.downcase
      price = bet.xpath('@price').text
      Competitor.new(name, price)
    end
  end
end