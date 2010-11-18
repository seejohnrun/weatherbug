module Weatherbug

  class LiveObservation < TransformableData

    register_transformer 'aws:station-id', :name => :station_id, :required => true
    register_transformer 'aws:temp-high/@units', :name => :temp_units, :required => true
    register_transformer 'aws:temp-high', :name => :temp_high, :required => true, :transform => :to_i
    register_transformer 'aws:temp-low', :name => :temp_low, :required => true, :transform => :to_i

    def self.from_document(document)
      lops = super
      raise ArgumentError.new('No such station') if lops.station_id.empty?
      lops
    end

    def station
      @station_reference ||= Weatherbug.get_station(self.station_id)
    end

    private

    attr_writer :station_reference

  end

end
