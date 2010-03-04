# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "spandex/list"
require_relative "bbc_iplayer_brand_list_card"

module InternetRadio
  module BBCiPlayer
    class MenuCard < Spandex::ListCard
      top_left :back

      jog_wheel_button card: BrandListCard, params: -> { { station: @list.selected } }

      def after_initialize
        @list = Spandex::List.new [
        "BBC Radio 1",
        "BBC Radio 2",
        "BBC Radio 3",
        "BBC Radio 4"
        ]
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
