# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "spandex/list"
require_relative "../models/bbc_iplayer_feed"
require_relative "bbc_iplayer_episode_list_card"

Thread.abort_on_exception = true

module InternetRadio
  class BBCiPlayerBrandListCard < Spandex::ListCard
    top_left :back

    jog_wheel_button card: BBCiPlayerEpisodeListCard, params: -> { { brand: @list.selected, feed: @feed } }

    def after_load
      @message = "Fetching programmes..."
      @feed = nil
      Thread.new do
        @feed = BBCiPlayer::Feed.new params[:station]
        @feed.fetch @application.hydra 
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
