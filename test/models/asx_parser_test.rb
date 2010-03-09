require "test/unit"
require_relative "../../lib/models/asx_parser"

module InternetRadio
  class ASXParserTest < Test::Unit::TestCase
    def test_good_parse
      response = Typhoeus::Response.new(:code => 200, :headers => "", :body => File.read(File.expand_path("r4.asx", "test")), :time => 0.3)
      Typhoeus::Hydra.hydra.stub(:get, "http://www.bbc.co.uk/radio/listen/live/r4.asx").and_return(response)

      assert_equal 32, ASXParser.uris_from("http://www.bbc.co.uk/radio/listen/live/r4.asx").size
    end

    def test_404_gives_no_uris
      response = Typhoeus::Response.new(:code => 404, :headers => "", :body => '', :time => 0.3)
      Typhoeus::Hydra.hydra.stub(:get, "http://www.bbc.co.uk/radio/listen/live/na4.asx").and_return(response)

      assert_equal 0, ASXParser.uris_from("http://www.bbc.co.uk/radio/listen/live/na.asx").size
    end
  end
end
