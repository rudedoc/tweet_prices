require 'spec_helper'

module TweetPrices
  describe XmlClient do
    before(:all) do
      stub_request(:get, "http://www.xml.com/premier-league").to_return(:status => 200,
                                                                        :body => MockPage.page_success('premier-league-data/football-premier-league.XML'),
                                                                        :headers => {})
      @xml = XmlClient.new({:url => "http://www.xml.com/premier-league"})
    end

    it "creates an array of Markets" do
      @xml.markets.each { |market| market.should be_a_kind_of(TweetPrices::QuotedMarket) }
    end

    its "markets has competitors" do
      @xml.markets.each { |market| market.competitors.each { |competitor| competitor.should be_a_kind_of(TweetPrices::Competitor) } }

    end

    its "markets count should be 10" do
      @xml.markets.count.should eq(10)
    end

    describe "first market" do
      before(:all) do
        @competitors = @xml.markets.first.competitors
      end

      it "has 3 competitors" do
        @competitors.count.should eq(3)
      end

      it "has a competitor called draw" do
        @competitors[0].name.should eq("draw")
      end

      it "has a competitor called everton" do
        @competitors[1].name.should eq("everton")
      end

      it "has a competitor called man city" do
        @competitors[2].name.should eq("man city")
      end
    end

  end
end