require 'spec_helper'

module TweetPrices
  describe Tweeter do
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
      xml = XML.new(XML_URL)
      oc = OddsChecker.new(OC_URL)
      @comparer = Comparer.new(xml, oc)

    end

    it "should tweet a price where a selected bookmaker is top price" do

    end

  end
end