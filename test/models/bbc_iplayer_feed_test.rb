require "test/unit"
require_relative "../../lib/models/bbc_iplayer_feed"

module InternetRadio
  module BBCiPlayer
    class FeedTest < Test::Unit::TestCase
      def setup_good_fetch
        response = Typhoeus::Response.new(:code => 200, :headers => "", :body => File.read(File.expand_path("r4.xml", "test")), :time => 0.3)
        Typhoeus::Hydra.hydra.stub(:get, "http://www.bbc.co.uk/radio/aod/availability/radio4.xml").and_return(response)
      end

      def test_fetch_brands
        setup_good_fetch

        feed = Feed.new("BBC Radio 4")
        feed.fetch
        assert_nil feed.error
        assert_equal 19, feed.brands.size
      end

      def test_fetch_error
        response = Typhoeus::Response.new(:code => 404, :headers => "", :body => "", :time => 0.3)
        Typhoeus::Hydra.hydra.stub(:get, "http://www.bbc.co.uk/radio/aod/availability/radio1.xml").and_return(response)

        feed = Feed.new("BBC Radio 1")
        feed.fetch
        assert_not_nil feed.error
        assert_empty feed.brands
      end
    end
  end
end
