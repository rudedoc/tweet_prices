require 'spec_helper'

module TweetPrices

  describe OddsCheckerClient do

    before(:all) do
      stub_request(:get, "http://www.oc.com/premier-league").
          to_return(:status => 200, :body => MockPage.page_success('premier-league-data/premier-League-oddschecker.html'), :headers => {})
      stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/everton-v-man-city/winner").
          to_return(:status => 200,
                    :body => MockPage.page_success("premier-league-data/Everton-v-Man-City.html"),
                    :headers => {})
      stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/aston-villa-v-qpr/winner").
          to_return(:status => 200,
                    :body => MockPage.page_success("premier-league-data/Aston-Villa-v-QPR.html"),
                    :headers => {})
      stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/southampton-v-liverpool/winner").
          to_return(:status => 200,
                    :body => MockPage.page_success("premier-league-data/Southampton-v-Liverpool.html"),
                    :headers => {})
      stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/stoke-v-west-brom/winner").
          to_return(:status => 200,
                    :body => MockPage.page_success("premier-league-data/Stoke-v-West-Brom.html"),
                    :headers => {})
      stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/swansea-v-arsenal/winner").
          to_return(:status => 200,
                    :body => MockPage.page_success("premier-league-data/Swansea-v-Arsenal.html"),
                    :headers => {})
      stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/man-utd-v-reading/winner").
          to_return(:status => 200,
                    :body => MockPage.page_success("premier-league-data/Man-Utd-v-Reading.html"),
                    :headers => {})
      stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/sunderland-v-norwich/winner").
          to_return(:status => 200,
                    :body => MockPage.page_success("premier-league-data/Sunderland-v-Norwich.html"),
                    :headers => {})
      stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/tottenham-v-fulham/winner").
          to_return(:status => 200,
                    :body => MockPage.page_success("premier-league-data/Tottenham-v-Fulham.html"),
                    :headers => {})
      stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/chelsea-v-west-ham/winner").
          to_return(:status => 200,
                    :body => MockPage.page_success("premier-league-data/Chelsea-v-West-Ham.html"),
                    :headers => {})
      stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/wigan-v-newcastle/winner").
          to_return(:status => 200,
                    :body => MockPage.page_success("premier-league-data/Wigan-v-Newcastle.html"),
                    :headers => {})
      @odds_checker = OddsCheckerClient.new({:url => "http://www.oc.com/premier-league"})
    end

    its "markets array should not be nil" do
      @odds_checker.markets.should_not be_nil
    end

    it "has 20 markets quotes" do
      @odds_checker.markets.count.should eq(20)
    end


    it "has an array of markets" do
      @odds_checker.markets.each { |market| market.should be_a_kind_of(QuotedMarket) }
    end

    its "markets has competitors" do
      @odds_checker.markets.each { |market| market.competitors.each { |competitor| competitor.should be_a_kind_of(TweetPrices::Competitor) } }
    end

    describe "market data" do

      before(:all) do
        @first_market_competitors = @odds_checker.markets.first.competitors
      end

      it "should have 3 competitors in first quoted market" do
        @first_market_competitors.count.should eq(3)
      end

      its "first competitor" do
        @first_market_competitors.first.name.should eq("draw")
      end

      its "last competitor" do
        @first_market_competitors.last.name.should eq("man city")
      end

    end


  end
end