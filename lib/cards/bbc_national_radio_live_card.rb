# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "spandex/list"
require_relative "../models/asx_parser"

module InternetRadio
  class BBCNationalRadioLiveCard < Spandex::Card
    include JogWheelListMethods

    top_left :back

    jog_wheel_button method: -> do
      pass_focus application: "mozart", method: "play_streams", params: InternetRadio::ASXParser.uris_from(@apps[@list.selected]).join(", ")
    end

    def after_initialize
      @apps = {}
      @apps["BBC Radio 1"] = "http://www.bbc.co.uk/radio/listen/live/r1.asx"
      @apps["BBC 1Xtra"] = "http://www.bbc.co.uk/radio/listen/live/r1x.asx"
      @apps["BBC Radio 2"] = "http://www.bbc.co.uk/radio/listen/live/r2.asx"
      @apps["BBC Radio 3"] = "http://www.bbc.co.uk/radio/listen/live/r3.asx"
      @apps["BBC Radio 4"] = "http://www.bbc.co.uk/radio/listen/live/r4.asx"
      @apps["BBC Radio 5 live"] = "http://www.bbc.co.uk/radio/listen/live/r5l.asx"
      @apps["BBC Radio 5 live sports extra"] = "http://www.bbc.co.uk/radio/listen/live/r5lsp.asx"
      @apps["BBC Radio 6"] = "http://www.bbc.co.uk/radio/listen/live/r6.asx"
      @apps["BBC Radio 7"] = "http://www.bbc.co.uk/radio/listen/live/r7.asx"
      @apps["BBC Asian Network"] = "http://www.bbc.co.uk/radio/listen/live/ran.asx"
      @list = Spandex::List.new @apps.keys
    end


    def show
      render %{
        <title>BBC streaming radio</title>
        <button position="top_left">Back</button>
        #{@list.to_s}
      }
    end
  end
end
