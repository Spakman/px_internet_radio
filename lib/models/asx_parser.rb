# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "nokogiri"
require "typhoeus"

module InternetRadio
  class ASXParser
    def self.uris_from(asx_url)
      uris = []
      response = Typhoeus::Request.get(asx_url)
      if response.code == 200
        asx_xml = Nokogiri::XML.parse response.body
        asx_xml.css("Entry ref").map { |ref| ref["href"] }
      end
    end
  end
end
