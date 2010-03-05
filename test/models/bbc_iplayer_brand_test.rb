require "test/unit"
require "typhoeus"
require_relative "../../lib/models/bbc_iplayer_brand"
require_relative "../../lib/models/bbc_iplayer_feed"

module InternetRadio
  module BBCiPlayer
    class BrandTest < Test::Unit::TestCase
      def setup
        @xml = Nokogiri::XML.parse File.read(File.expand_path("r4.xml", "test"))
      end

      def test_sort_array_of_brands
        list = [ Brand.new("B", "b", @xml), Brand.new("C", "c", @xml), Brand.new("A", "a", @xml)]
        list.sort!
        assert_equal %w{ a b c }, list.sort.map(&:name)
      end

      def test_to_s
        assert_equal "c", Brand.new("C", "c", @xml).to_s
      end

      def test_episodes
        brand = Brand.new("b006qfvv", "Shipping Forecast", @xml)
        assert_equal 46, brand.episodes.size
      end
    end
  end
end
