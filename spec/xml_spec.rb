require 'spec_helper'

module TweetPrices

  describe XmlClient do
    before(:all) do
      stub_request(:get, "http://www.xml.com/premier-league").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/football-premier-league.XML'), :headers => {})
      @xml = XmlClient.new(XML_URL)
    end

    describe "gets data from the XML feed - " do

      it "cycles through the markets in the XML and creates an array of Markets" do
        @xml.markets.count.should == 10
      end

      its "#market Array items should be Market Objects" do
        @xml.markets.each do |market|
          market.should be_a_kind_of(TweetPrices::Market)
        end
      end

      it "has competitors in each Market" do
        @xml.markets.each do |market|
          market.competitors.each do |competitor|
            competitor.should be_a_kind_of(TweetPrices::Competitor)
          end
        end
      end
    end

    describe "has markets in the #markets array with certain attributes -" do
      it "has an array of competitor names" do
        @xml.markets.first.competitor_names.should include("everton", "man city", "draw")
      end
    end
  end

end