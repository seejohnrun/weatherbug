module WeatherBug

  class StationHint < TransformableData

    register_transformer '@id', :name => :station_id
    register_transformer '@name'

    def station
      @station ||= WeatherBug.get_station(station_id)
    end

  end

end
