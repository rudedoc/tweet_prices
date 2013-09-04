module TweetPrices
  class OddsCheckerClient
    attr_accessor :url, :markets

    HOST_URL = "http://www.oddschecker.com"
    BOOKMAKERS = ["BY", "PP"]

    def initialize(options)
      @url = options[:url]
      top_level_doc = html_doc(@url)
      market_urls = get_market_urls(top_level_doc)
      @markets = create_markets(market_urls)
    end

    private

    def create_markets(market_urls)
      markets = []
      BOOKMAKERS.each do |bookie|
        market_urls.each do |market_url|
          markets << create_market(html_doc(market_url), bookie)
        end
      end
      markets
    end

    def create_market(html_doc, bookmaker)
      market = QuotedMarket.new(bookmaker)
      html_doc.xpath("//tbody[@id='t1']/tr").each do |competitor_xml|
        market.competitors << create_competitor(competitor_xml, bookmaker)
      end
      market
    end

    def create_competitor(competitor_xml, bookmaker)
      competitor_id = competitor_xml.xpath('@data-participant-id').text
      price = competitor_xml.xpath("td[@id='#{competitor_id}_#{bookmaker}']").text
      name = competitor_xml.xpath('td[2]').text.downcase
      Competitor.new(name, price)
    end

    # TODO: rescue from HTTP exceptions
    def html_doc(market_url)
      Nokogiri::HTML(open(market_url))
    end

    # TODO: should follow same pattern as XML Client
    def get_market_urls(html_doc)
      html_doc.xpath("//tr[@class='match-on']").collect do |market|
        HOST_URL + market.xpath('td[5]/a/@href').text
      end
    end
  end
end