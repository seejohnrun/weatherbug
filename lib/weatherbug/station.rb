module Weatherbug

  class Station < TransformableData

    register_transformer '@id', :name => :station_id, :required => true
    register_transformer '@name', :name => :name, :required => true, :transform => :to_s
    register_transformer '@distance', :name => :distance, :transform => :to_f
    register_transformer '@zipcode', :name => :zip_code
    register_transformer '@city-code', :name => :city_code, :transform => :to_i
    register_transformer '@station-type', :name => :station_type
    register_transformer '@city', :name => :city, :required => true
    register_transformer '@state', :name => :state
    register_transformer '@country', :name => :country
    register_transformer '@latitude', :name => :latitude, :required => true, :transform => :to_f
    register_transformer '@longitude', :name => :longitude, :required => true, :transform => :to_f  

    def self.from_document(document)
      station = super
      raise ArgumentError.new('No such station') if station.station_id.empty?
      station
    end

    def live_observation(unit = :f)
      Weatherbug.live_observation(self, unit)
    end

  end

end
