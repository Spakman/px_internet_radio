# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "spandex/list"
require_relative "../models/bbc_iplayer_feed"
require_relative "bbc_iplayer_episode_view_card"

module InternetRadio
  module BBCiPlayer
    # Lists all episodes that are available for the specified Brand.
    class EpisodeListCard < Spandex::ListCard
      top_left :back

      jog_wheel_button card: EpisodeViewCard, params: -> { { episode: @list.selected } }

      def after_load
        @list = Spandex::List.new params[:brand].episodes
      end

      def show
        render %{
        <title>#{params[:brand]}</title>
        <button position="top_left">Back</button>
        #{@list.to_s}
      }
      end
    end
  end
end
