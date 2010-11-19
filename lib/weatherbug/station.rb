module Weatherbug

  class Station < TransformableData

    register_transformer '@id', :name => :station_id
    register_transformer '@name'
    register_transformer '@distance', :transform => :to_f
    register_transformer '@zipcode', :name => :zip_code
    register_transformer '@city-code', :transform => :to_i
    register_transformer '@station-type'
    register_transformer '@city'
    register_transformer '@state'
    register_transformer '@country'
    register_transformer '@latitude', :transform => :to_f
    register_transformer '@longitude', :transform => :to_f  

    def self.from_document(document)
      station = super
      raise ArgumentError.new('No such station') if station.station_id.empty?
      station
    end

    def live_observation(unit = :f)
      Weatherbug.live_observation(self, unit)
    end

    def forecast
      Weatherbug.forecast(:latitude => latitude, :longitude => longitude)
    end

  end

end
