require "date"
require "typhoeus"
require "nokogiri"

module InternetRadio
  module BBCiPlayer
    class Brand
      attr_reader :name, :id

      def initialize(name, id)
        @name = name
        @id = id
      end

      def hash
        (@name.hash.to_s + @id.hash.to_s).to_i
      end

      def to_s
        @name
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
        if object.class == Brand
          if @name == object.name and @id = object.id
            true
          else
            false
          end
        else
          false
        end
      end
    end

    class Episode
      attr_reader :name, :id

      def initialize(name, id)
        @name = name
        @id = id
      end

      def to_s
        @name
      end
    end

    class Feed
      attr_reader :brands, :error

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

      def fetch(hydra)
        request = Typhoeus::Request.new(@uri)
        request.on_complete do |response|
          if response.code == 200
            @xml = Nokogiri::XML.parse response.body
          else
            @error = "There was a problem with this feed."
          end
        end
        hydra.queue request
        hydra.run
      end

      def parse_brands(xml)
        now = Time.now.to_date
        xml.css('entry').each do |entry|
          availability = entry.css("availability")
          if Date.parse(availability.attr("start")) < now
            unless Date.parse(availability.attr("end")) < now
              name = entry.xpath("parents/parent[@type='Brand']").text
              unless name.empty?
                id = entry.xpath("parents/parent[@type='Brand']").attr("pid")
                @brands << Brand.new(name, id)
              end
            end
          end
        end
        @brands.uniq!.sort!
      end

      def brands
        unless @xml.nil?
          parse_brands @xml
        end
        @brands
      end

      def episodes(brand)
        unless @xml
          return []
        end
        episodes = []
        pid = nil
        @xml.xpath("//entry/parents/parent[@type='Brand']").each do |brand_node|
          if brand_node.text == brand.name
            name = brand_node.parent.parent.css("title").text
            id = brand_node["pid"]
            episodes << Episode.new(name, id)
          end
        end
        episodes
      end
    end
  end
end
