require "test/unit"
require_relative "../../lib/models/bbc_iplayer_episode"

module InternetRadio
  module BBCiPlayer
    class EpisodeTest < Test::Unit::TestCase
      def setup
        response = Typhoeus::Response.new(:code => 200, :headers => "", :body => File.read(File.expand_path("b00r0tfb.xml", "test")), :time => 0.3)
        Typhoeus::Hydra.hydra.stub(:get, "http://www.bbc.co.uk/mediaselector/4/mtis/stream/b00r0tfb").and_return(response)

        response = Typhoeus::Response.new(:code => 200, :headers => "", :body => File.read(File.expand_path("iplayer_intl_stream_wma_uk_concrete", "test")), :time => 0.3)
        Typhoeus::Hydra.hydra.stub(:get, "http://www.bbc.co.uk/mediaselector/4/asx/b00r0tfb/iplayer_intl_stream_wma_uk_concrete").and_return(response)
        @episode = Episode.new "p006mlcs", Nokogiri::XML.parse(File.read(File.expand_path("r4.xml", "test")))
      end

      def test_initialize_sets_attributes_correctly
        assert_equal "A Good Read, 02/03/2010", @episode.title
        assert_equal "Sue MacGregor talks to museum curator Ken Arnold and writer Jay Griffiths.", @episode.synopsis
        assert_equal 1800, @episode.duration
        assert_kind_of Time, @episode.start
        assert_kind_of Time, @episode.end
        assert_equal "http://www.bbc.co.uk/mediaselector/4/mtis/stream/b00r0tfb", @episode.media_selector_url
      end

      def test_availabilty
        assert @episode.available?
      end

      def test_to_s
        assert_equal @episode.title, @episode.to_s
      end

      def test_urls
        assert_equal [ "mms://wm-acl.bbc.co.uk/wms/radio4fmcoyopa/radio_4_fm_-_tuesday_1630.wma", "mms://wm-acl.bbc.co.uk/wms2/radio4fmcoyopa/radio_4_fm_-_tuesday_1630.wma" ], @episode.urls
      end

      def test_uniq
        episode2 = Episode.new "p006mlcs", Nokogiri::XML.parse(File.read(File.expand_path("r4.xml", "test")))
        assert_equal 1, [ @episode, episode2 ].uniq.size
      end
    end
  end
end
