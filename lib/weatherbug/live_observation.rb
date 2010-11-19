module WeatherBug

  class LiveObservation < TransformableData

    register_transformer 'aws:station-id'
    register_transformer 'aws:station', :name => :station_name
    register_transformer 'aws:temp-high/@units', :name => :temp_units
    register_transformer 'aws:temp-high', :name => :temp_high, :transform => :to_i
    register_transformer 'aws:temp-low', :name => :temp_low, :transform => :to_i
    register_transformer 'aws:dew-point', :transform => :to_i
    register_transformer 'aws:elevation', :transform => :to_i
    register_transformer 'aws:feels-like', :transform => :to_i
    register_transformer 'aws:humidity', :transform => :to_i
    register_transformer 'aws:wind-direction'
    register_transformer 'aws:wind-speed', :transform => :to_i
    register_transformer 'aws:pressure', :transform => :to_f

    def self.from_document(document)
      lops = super
      raise ArgumentError.new('No such station') if lops.station_id.empty?
      lops
    end

    def station
      @station_reference ||= WeatherBug.get_station(self.station_id)
    end

    private

    attr_writer :station_reference

  end

end
