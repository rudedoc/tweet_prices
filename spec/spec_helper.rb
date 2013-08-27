require 'tweet_prices'
require 'webmock/rspec'
require 'rspec'
require 'pry'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

module MockPage
  def self.page_success(page)
    get_page(page)
  end

  private
  def self.get_page(page)
    Dir.chdir(File.dirname(__FILE__) + '/fixtures')
    File.open(page, 'r').read {|line| line}
  end
end

XML_URL = "http://www.xml.com/premier-league"
OC_URL = "http://www.oc.com/premier-league"
XML_FIXTURE = "premier-league-data/football-premier-league.XML"
OC_FIXTURE = "premier-league-data/premier-league-oddschecker.html"