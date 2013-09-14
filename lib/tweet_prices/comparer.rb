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

    def grouped_markets
      markets.group_by(&:name)
    end

    def sorted_markets
      sorting_hash = {}
      grouped_markets.values.each do |market|
        market.each do |quote|
          quote.competitors.each do |competitor|
            if sorting_hash[competitor.name] == nil
              sorting_hash[competitor.name] = [[competitor.price_decimal, quote.bookmaker]]
            else
              sorting_hash[competitor.name] << [competitor.price_decimal, quote.bookmaker]
            end
            sorting_hash[competitor.name].sort! { |comp_a, comp_b| comp_b[0] <=> comp_a[0] }
          end
        end
      end
      sorting_hash
    end
  end
end
