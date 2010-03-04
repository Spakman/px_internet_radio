# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "time"
require "nokogiri"

module InternetRadio
  module BBCiPlayer
    class Episode
      attr_reader :title, :start, :end, :synopsis, :duration

      # Takes a node object and parses it to create the Episode attributes.
      def initialize(node)
        @title = node.css("title").text
        @start = Time.parse(node.css("availability").attr("start"))
        @end = Time.parse(node.css("availability").attr("end"))
        @synopsis = node.css("synopsis").text
        @duration = node.css("broadcast").attr("duration").to_i
      end

      def to_s
        @title
      end
      
      # Can this Episode be streamed now?
      def available?
        Time.now > @start and Time.now < @end
      end
    end
  end
end
