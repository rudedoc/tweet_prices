require 'spec_helper'

module TweetPrices

  describe OddsCheckerClient do

    before(:all) do
      stub_request(:get, "http://www.oc.com/premier-league").to_return(:status => 200, :body => MockPage.page_success('premier-league-data/premier-League-oddschecker.html'), :headers => {})
      @oc = OddsCheckerClient.new(OC_URL)
    end

    it "should build a hash of quoted events from OC -" do
      @oc.events.each do |event|
        event.should be_a_kind_of(Hash)
      end
    end
  end
end