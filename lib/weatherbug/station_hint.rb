module Weatherbug

  class StationHint < TransformableData

    register_transformer '@id', :name => :station_id
    register_transformer '@name'

    def station
      @station ||= Weatherbug.get_station(station_id)
    end

  end

end
