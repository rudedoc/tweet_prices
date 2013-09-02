module TweetPrices
  class OddsCheckerClient
    attr_accessor :markets, :market_urls

    HOST_URL = "http://www.oddschecker.com"

    def initialize(options)
      data = html_doc(options[:url])
      @market_urls = parse_urls(data)
      @markets = []
    end

    private

    # TODO: rescue from HTTP exceptions
    def html_doc(market_url)
      Nokogiri::HTML(open(market_url))
    end

    # TODO: should follow same pattern as XML Client
    def parse_urls(data)
      data.xpath("//tr[@class='match-on']").collect { |event| event.xpath('td[5]/a/@href').text }
    end

    def get_market_docs
      market_urls.collect { |market_url| html_doc(HOST_URL + market_url) }
    end




  end

end