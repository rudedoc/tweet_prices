require 'spec_helper'

module TweetPrices
  describe XmlClient do
    before(:all) do
      stub_request(:get, "http://www.xml.com/premier-league").to_return(:status => 200,
                                                                        :body => MockPage.page_success('premier-league-data/football-premier-league.XML'),
                                                                        :headers => {})
      let(:xml, XmlClient.new({:url => "http://www.xml.com/premier-league"}))
    end

    it "creates an array of Markets" do
      xml.markets.each { |market| market.should be_a_kind_of(TweetPrices::QuotedMarket) }
    end

    its "markets has competitors" do
      xml.markets.each { |market| market.competitors.each { |competitor| competitor.should be_a_kind_of(TweetPrices::Competitor) } }
    end
  end
end