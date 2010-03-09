# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "spandex/list"
require_relative "bbc_national_radio_live_card"
require_relative "bbc_iplayer_card"

module InternetRadio
  class MainMenuCard < Spandex::Card
    include JogWheelListMethods

    top_left :back
    jog_wheel_button method: -> do
      case @list.selected
      when "Favourites"
#       load_card InternetRadio::FavouritesCard
      when "BBC national radio live"
        load_card InternetRadio::BBCNationalRadioLiveCard
      when "BBC local radio live"
#       load_card InternetRadio::BBCLocalRadioLiveCard
      when "BBC iPlayer national stations"
        load_card InternetRadio::BBCiPlayer::MenuCard
      end
    end

    def after_initialize
      @list ||= Spandex::List.new [ "Favourites", "BBC national radio live", "BBC local radio live", "BBC iPlayer national stations" ]
    end


    def show
      render %{
        <button position="top_left">Back</button>
        #{@list.to_s}
      }
    end
  end
end
