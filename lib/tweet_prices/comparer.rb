module TweetPrices

  BOOKMAKERS = ["BY", "PP"]

  class Comparer
    attr_reader :common_events, :comparison_sets, :xml, :odds_checker
    def initialize(xml, oc)
      @xml = xml
      @odds_checker = oc
      get_common_events
      get_comparison_sets
    end

    private

    def build_competitor(competitor_xml, bookie)
      competitor_id = competitor_xml.xpath('@data-participant-id').text
      price = competitor_xml.xpath("td[@id='#{competitor_id}_#{bookie}']").text
      name = competitor_xml.xpath('td[2]').text.downcase
      Competitor.new(name, price)
    end

    def parse_market(html_doc, bookie)
      market = QuotedMarket.new(bookie)
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
      xml.markets.each do |xml_market|
        if matching_competitors?(xml_market, market)
          comparison_set.market_quotes << xml_market unless comparison_set.market_quotes.collect { |quote| quote.bookmaker }.include?("XML")
        end
      end
      comparison_set
    end

    def get_comparison_sets
      @comparison_sets = []
      @common_events.each do |event|
        html_doc = Nokogiri::HTML((open event[:url]))
        BOOKMAKERS.each do |bookie|
          @comparison_sets << build_comparison_set(html_doc, bookie)
        end
      end
      @comparison_sets
    end

    def get_common_events
      xml_event_list = xml.markets.collect { |market| market.competitors.collect { |competitor| competitor.name } }
      @common_events = []
      odds_checker.events.each do |event|
        xml_event_list.each do |market|
          if (event[:competitors] & market).count == 3
            @common_events << event
          end
        end
      end
      @common_events
    end
  end

end