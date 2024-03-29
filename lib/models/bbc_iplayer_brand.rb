# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

module InternetRadio
  module BBCiPlayer
    class Brand
      attr_reader :name, :pid

      alias_method :to_s, :name

      # This takes a name parameter simply for optimisation.
      def initialize(pid, name, xml_document)
        feed = feed
        @pid = pid
        @name = name
        @xml_document = xml_document
      end

      def episodes
        episodes = []
        @xml_document.xpath("//entry/parents/parent[@pid='#{@pid}']").each do |brand_node|
          episode = Episode.new(brand_node.parent.parent.css("pid").text, @xml_document)
          episodes << episode if episode.available?
        end
        episodes.uniq
      end

      def hash
        (@name.hash.to_s + @pid.hash.to_s).to_i
      end

      def <=>(brand)
        if @name > brand.name
          1
        elsif @name == brand
          0
        else
          -1
        end
      end

      def eql?(object)
        if object.class == self.class
          if @name == object.name and @pid = object.pid
            true
          else
            false
          end
        else
          false
        end
      end
    end
  end
end
