module TweetPrices
  class OddsCheckerClient
    attr_accessor :events

    HOST_URL = "http://www.oddschecker.com"

    def initialize(url)
      parse_events(Nokogiri::HTML(open(url)))
    end

    private

    def parse_events(data)
      @events = []
      data.xpath("//tr[@class='match-on']").each do |event|
        competitors = []
        competitors << event.xpath('td[2]/p/span[2]').text.downcase
        competitors << event.xpath('td[3]/p/span[2]').text.downcase
        competitors << event.xpath('td[4]/p/span[2]').text.downcase
        url = event.xpath('td[5]/a/@href').text
        @events << {:competitors => competitors, :url => (HOST_URL + url)}
      end
      @events
    end
  end

end