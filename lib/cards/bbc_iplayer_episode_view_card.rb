# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "spandex/list"
require_relative "../models/bbc_iplayer_feed"

module InternetRadio
  module BBCiPlayer
    # Displays information about a single Episode.
    class EpisodeViewCard < Spandex::ListCard
      top_left :back

      jog_wheel_button method: -> do
        pass_focus application: "mozart", method: "play_stream", params: @episode.urls.first
      end

      def after_load
        @episode = params[:episode]
      end

      def show
        render %{
        <title>#{@episode.title}</title>
        <button position="top_left">Back</button>
        <text wrap="yes" x="10" y="18" width="236">#{@episode.synopsis}</text>
        <text x="20" y="48" width="216">#{@episode.duration} mins</text>
        <text halign="right" width="236" y="48">Until: #{@episode.end.strftime("%d %B %H:%M")}</text>
      }
      end
    end
  end
end
