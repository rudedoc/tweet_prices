require 'spec_helper'

module TweetPrices
  describe TweetPrices do
    describe Comparer do
      before(:all) do
        stub_request(:get, "http://www.xml.com/premier-league").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/football-premier-league.XML'), :headers => {})
        stub_request(:get, "http://www.oc.com/premier-league").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/premier-League-oddschecker.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/everton-v-man-city/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Everton-v-Man-City.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/southampton-v-liverpool/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Southampton-v-Liverpool.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/stoke-v-west-brom/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Stoke-v-West-Brom.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/swansea-v-arsenal/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Swansea-v-Arsenal.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/sunderland-v-norwich/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Sunderland-v-Norwich.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/tottenham-v-fulham/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Tottenham-v-Fulham.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/chelsea-v-west-ham/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Chelsea-v-West-Ham.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/wigan-v-newcastle/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Wigan-v-Newcastle.html'), :headers => {})
        xml = XmlClient.new({:url => XML_URL})
        oc = OddsCheckerClient.new({:url => OC_URL})
        @comparer = Comparer.new(xml, oc)
      end

      it "should identify common events between XML and OC" do
        @comparer.common_events.count.should == 8
      end

      it "should get all market data for each of the common events" do
        @comparer.comparison_sets.first.should be_a_kind_of(ComparisonSet)
      end
    end

    describe ComparisonSet do
      before(:all) do
        stub_request(:get, "http://www.xml.com/premier-league").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/football-premier-league.XML'), :headers => {})
        stub_request(:get, "http://www.oc.com/premier-league").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/premier-League-oddschecker.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/everton-v-man-city/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Everton-v-Man-City.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/southampton-v-liverpool/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Southampton-v-Liverpool.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/stoke-v-west-brom/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Stoke-v-West-Brom.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/swansea-v-arsenal/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Swansea-v-Arsenal.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/sunderland-v-norwich/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Sunderland-v-Norwich.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/tottenham-v-fulham/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Tottenham-v-Fulham.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/chelsea-v-west-ham/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Chelsea-v-West-Ham.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/wigan-v-newcastle/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Wigan-v-Newcastle.html'), :headers => {})
        xml = XmlClient.new({:url => XML_URL})
        oc = OddsCheckerClient.new({:url => OC_URL})
        @comparison_set = Comparer.new(xml, oc).comparison_sets.first
      end

      it "should have an array of Markets" do
        @comparison_set.market_quotes.first.should be_a_kind_of(QuotedMarket)
      end

      it "should have a hash of markets with competitors for keys" do
        @comparison_set.hashed_market_quotes.should have_key("man city")
      end

      it "should sort bookmaker quotes" do
        @comparison_set.hashed_market_quotes["man city"].last.should include("BY")
      end
    end
  end
end