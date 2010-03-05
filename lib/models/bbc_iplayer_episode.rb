# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "time"
require "nokogiri"
require "typhoeus"

module InternetRadio
  module BBCiPlayer
    class Episode
      attr_reader :title, :start, :end, :synopsis, :duration, :media_selector_url

      # Takes a node object and parses it to create the Episode attributes.
      def initialize(pid, markup)
        xml = Nokogiri::XML.parse markup
        node = xml.xpath("//schedule/entry[@pid='#{pid}']").first
        @title = node.css("title").text
        @start = Time.parse(node.css("availability").attr("start").content)
        @end = Time.parse(node.css("availability").attr("end").content)
        @synopsis = node.css("synopsis").text
        @duration = node.css("broadcast").attr("duration").content.to_i
        @media_selector_url = node.xpath("links/link[@type='mediaselector']").first.text
      end

      def to_s
        @title
      end
      
      # Can this Episode be streamed now?
      def available?
        Time.now > @start and Time.now < @end
      end

      # Makes two HTTP requests to fetch the ASX playlist, then parses
      # it for the URLs.
      def urls
        urls = []
        response = Typhoeus::Request.get(@media_selector_url)
        selector_xml = Nokogiri::XML.parse response.body
        selector_xml.css("media[service='iplayer_intl_stream_wma_uk_concrete']").each do |media|
          playlist = media.css("connection").first['href']

          response = Typhoeus::Request.get(playlist)
          asx_xml = Nokogiri::XML.parse response.body
          urls = asx_xml.css("Entry ref").map { |ref| ref["href"] }
        end
        urls
      end
    end
  end
end
