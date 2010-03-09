# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "date"
require "typhoeus"
require "nokogiri"
require_relative "bbc_iplayer_episode"
require_relative "bbc_iplayer_brand"

module InternetRadio
  module BBCiPlayer
    class Feed
      attr_reader :brands, :error, :xml_document

      STATIONS = {}
      STATIONS["BBC Radio 1"] = "radio1.xml"
      STATIONS["BBC 1Xtra"] = "1xtra.xml"
      STATIONS["BBC Radio 2"] = "radio2.xml"
      STATIONS["BBC Radio 3"] = "radio3.xml"
      STATIONS["BBC Radio 4"] = "radio4.xml"

      def initialize(station)
        @station = station
        @uri = "http://www.bbc.co.uk/radio/aod/availability/#{STATIONS[station]}"
        @brands = []
      end

      def fetch
        response = Typhoeus::Request.get(@uri)
        if response.code == 200
          @xml_document = Nokogiri::XML.parse response.body
        else
          @error = "There was a problem with this feed."
        end
      end

      def brands
        return [] unless @xml_document
        @brands = []
        now = Time.now.to_date
        @xml_document.css('entry').each do |entry|
          availability = entry.css("availability")
          if Date.parse(availability.attr("start").content) < now
            unless Date.parse(availability.attr("end").content) < now
              name = entry.xpath("parents/parent[@type='Brand']").text
              unless name.empty?
                pid = entry.xpath("parents/parent[@type='Brand']").attr("pid").content
                @brands << Brand.new(pid, name, @xml_document)
              end
            end
          end
        end
        unless @brands.empty?
          @brands.uniq!.sort!
        end
        @brands
      end
    end
  end
end
