module TweetPrices

  class Comparer
    attr_reader :xml_client, :oddschecker_client
    def initialize(options)
      @xml_client = TweetPrices::XmlClient.new({:url => options[:xml_url]})
      @oddschecker_client = TweetPrices::OddsCheckerClient.new({:url => options[:oddschecker_url]})
    end

    def markets
      xml_client.markets | oddschecker_client.markets
    end

    def common_markets
      markets.sort! { |markets|  }
    end

  end

end