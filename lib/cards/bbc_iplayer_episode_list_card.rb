# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "spandex/list"
require_relative "../models/bbc_iplayer_feed"

module InternetRadio
  class BBCiPlayerEpisodeListCard < Spandex::ListCard
    top_left :back

    def after_load
      @list = Spandex::List.new params[:feed].episodes(params[:brand])
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
