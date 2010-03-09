# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "spandex/list"
require_relative "../models/bbc_iplayer_feed"
require_relative "bbc_iplayer_episode_list_card"

Thread.abort_on_exception = true

module InternetRadio
  module BBCiPlayer
    # Lists the brands that have available episodes for a specified station.
    class BrandListCard < Spandex::Card
      include JogWheelListMethods

      top_left :back

      jog_wheel_button method: -> do
        if @list
          load_card InternetRadio::BBCiPlayer::EpisodeListCard, { brand: @list.selected }
        end
      end

      def after_load
        if params[:station] != @station
          @list = nil
          @station = params[:station]
          @feed = nil
          @message = "Fetching programmes..."
          Thread.new do
            @feed = Feed.new params[:station]
            @feed.fetch
            if @feed.error
              @message = "There was a problem with this feed"
            elsif @feed.brands.empty?
              @message = "There are no programmes available"
            else
              @list = Spandex::List.new @feed.brands
            end
            show
          end
        end
      end

      def show
        if @list
          render %{
          <title>BBC iPlayer: #{params[:station]}</title>
          <button position="top_left">Back</button>
          #{@list.to_s}
        }
        else
          render %{
          <title>BBC iPlayer: #{params[:station]}</title>
          <button position="top_left">Back</button>
          <text valign="centre" halign="centre">#{@message}</text>
        }
        end
      end
    end
  end
end
