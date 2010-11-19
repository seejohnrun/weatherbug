module WeatherBug

  class Forecast < TransformableData

    register_transformer 'aws:title', :required => true   
    register_transformer 'aws:city'
    register_transformer 'aws:short-title'
    register_transformer 'aws:icon'
    register_transformer 'aws:description'
    register_transformer 'aws:prediction'
    register_transformer 'aws:lo', :name => :temp_low, :transform => :to_i
    register_transformer 'aws:hi', :name => :temp_high, :transform => :to_i
    register_transformer 'aws:hi/@units', :name => :temp_units
    register_transformer 'aws:prob-of-precip', :name => :probability_of_precipitation

  end

end
