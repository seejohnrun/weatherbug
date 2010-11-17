module Weatherbug

  class Station < TransformableData 

    register_transformer 'id', :required => true
    register_transformer 'name', :required => true, :transform => :to_s
    register_transformer 'distance', :transform => :to_f
    register_transformer 'zipcode', :name => :zip_code
    register_transformer 'city-code', :name => :city_code, :transform => :to_i
    register_transformer 'station-type', :name => :station_type, :required => true
    register_transformer 'city', :required => true
    register_transformer 'state'
    register_transformer 'country'
    register_transformer 'latitude', :required => true, :transform => :to_f
    register_transformer 'longitude', :required => true, :transform => :to_f

  end

end
