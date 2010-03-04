require "test/unit"
require_relative "../../lib/models/bbc_iplayer_feed"

class BBCiPlayerFeedTest < Test::Unit::TestCase
  def setup_good_fetch
    response = Typhoeus::Response.new(:code => 200, :headers => "", :body => File.read(File.expand_path("r4.xml", "test")), :time => 0.3)
    @hydra = Typhoeus::Hydra.new
    @hydra.stub(:get, "http://www.bbc.co.uk/radio/aod/availability/radio4.xml").and_return(response)
  end

  def test_fetch_brands
    setup_good_fetch

    feed = InternetRadio::BBCiPlayer::Feed.new("BBC Radio 4")
    feed.fetch(@hydra)
    assert_nil feed.error
    assert_equal 91, feed.brands.size
  end

  def test_fetch_error
    response = Typhoeus::Response.new(:code => 400, :headers => "", :body => "", :time => 0.3)
    hydra = Typhoeus::Hydra.new
    hydra.stub(:get, "http://www.bbc.co.uk/radio/aod/availability/radio1.xml").and_return(response)

    feed = InternetRadio::BBCiPlayer::Feed.new("BBC Radio 1")
    feed.fetch(hydra)
    assert_not_nil feed.error
    assert_empty feed.brands
  end

  def test_episodes
    setup_good_fetch

    feed = InternetRadio::BBCiPlayer::Feed.new("BBC Radio 4")
    feed.fetch(@hydra)
    assert_equal 46, feed.episodes(InternetRadio::BBCiPlayer::Brand.new("Shipping Forecast", "b006qfvv")).size
  end
end
