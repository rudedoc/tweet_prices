require 'spec_helper'

module TweetPrices
  describe TweetPrices do
    describe Comparer do
      before(:each) do
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
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/aston-villa-v-qpr/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Aston-Villa-v-QPR.html'), :headers => {})
        stub_request(:get, "http://www.oddschecker.com/football/english/premier-league/man-utd-v-reading/winner").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/Everton-v-Man-City.html'), :headers => {})
        @comparer = Comparer.new({:xml_url => "http://www.xml.com/premier-league", :oddschecker_url => "http://www.oc.com/premier-league"})
      end

      it "has an xml_client object" do
        @comparer.xml_client.should be_a_kind_of(TweetPrices::XmlClient)
      end


      it "has an oddschecker_client object" do
        @comparer.oddschecker_client.should be_a_kind_of(TweetPrices::OddsCheckerClient)
      end

      its "xml_client has x markets" do
        @comparer.xml_client.markets.count.should be(10)
      end

      its "oddschecker_client has x markets" do
        @comparer.oddschecker_client.markets.count.should be(20)
      end

      it "has x common markets" do
        puts "-------------------------"
        @comparer.markets.each do |market|
          puts " "
          puts market.bookmaker.upcase
          market.competitors.each do |comp|
            puts comp.name
          end

        end
      end

    end
  end
end