require "test/unit"
require_relative "../../lib/models/bbc_iplayer_brand"

module InternetRadio
  module BBCiPlayer
    class BrandTest < Test::Unit::TestCase
      def test_sort_array_of_brands
        list = [ Brand.new("B", "b"), Brand.new("C", "c"), Brand.new("A", "a")]
        list.sort!
        assert_equal %w{ A B C }, list.sort.map(&:name)
      end

      def test_to_s
        assert_equal "B", Brand.new("B", "b").to_s
      end
    end
  end
end
