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
    end

    describe "sorts it's competitors by name" do
      before(:all) do
        @markets = @xml.markets
      end

       it "in all market" do
         @markets[0].competitors[0].name.should eq("draw")
         @markets[0].competitors[1].name.should eq("everton")
         @markets[0].competitors[2].name.should eq("man city")

         @markets[1].competitors[0].name.should eq("aston villa")
         @markets[1].competitors[1].name.should eq("draw")
         @markets[1].competitors[2].name.should eq("q.p.r.")
       end

    end

  end
end