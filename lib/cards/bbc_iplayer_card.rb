# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "spandex/list"
require_relative "bbc_iplayer_brand_list_card"

module InternetRadio
  module BBCiPlayer
    class MenuCard < Spandex::Card
      include JogWheelListMethods

      top_left :back

      jog_wheel_button card: BrandListCard, params: -> { { station: @list.selected } }

      def after_initialize
        @list = Spandex::List.new Feed::STATIONS.keys
      end

      def show
        render %{
        <title>BBC iPlayer stations</title>
        <button position="top_left">Back</button>
        #{@list.to_s}
      }
      end
    end
  end
end
