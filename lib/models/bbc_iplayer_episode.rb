# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "time"
require "nokogiri"
require "typhoeus"

module InternetRadio
  module BBCiPlayer
    class Episode
      attr_reader :pid, :title, :start, :end, :synopsis, :duration, :media_selector_url

      # Takes a node object and parses it to create the Episode
      # attributes.
      #
      # Confusingly, there can be more than one <entry> with a
      # certain PID (this could be when a programme is broadcast
      # on LW and FM, for example). We try to find one that is
      # available. This certainly isn't perfect, but should
      # suffice for now.
      def initialize(pid, xml_document)
        @pid = pid

        xml_document.xpath("//schedule/entry").each do |entry|
          if entry.css("pid").text == pid
            @title = entry.css("title").text
            @start = Time.parse(entry.css("availability").attr("start").content)
            @end = Time.parse(entry.css("availability").attr("end").content)
            @synopsis = entry.css("synopsis").text
            @duration = entry.css("broadcast").attr("duration").content.to_i
            @media_selector_url = entry.xpath("links/link[@type='mediaselector']").first.text

            if available?
              break
            end
          end
        end
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

      def hash
        @pid.to_i
      end

      def eql?(object)
        if object.class == self.class and @pid == object.pid
          true
        else
          false
        end
      end
    end
  end
end
