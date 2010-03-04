require "test/unit"
require_relative "../../lib/models/bbc_iplayer_episode"

class BBCiPlayerEpisodeTest < Test::Unit::TestCase
  def setup
    xml = Nokogiri::XML.parse File.read(File.expand_path("r4.xml", "test"))
    node = xml.xpath("//entry").first

    @episode = InternetRadio::BBCiPlayer::Episode.new(node)
  end

  def test_initialize_sets_attributes_correctly
    assert_equal "Today in Parliament, 24/02/2010", @episode.title
    assert_equal "News, views and features on today's stories in Parliament with Robert Orchard.", @episode.synopsis
    assert_equal 1800, @episode.duration
    assert_kind_of Time, @episode.start
    assert_kind_of Time, @episode.end
  end

  def test_availabilty
    refute @episode.available?
  end

  def test_to_s
    assert_equal @episode.title, @episode.to_s
  end
end
